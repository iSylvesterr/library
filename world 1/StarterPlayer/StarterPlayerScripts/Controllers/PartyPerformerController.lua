-- Decompiled with Potassium's decompiler.

local ContentProvider = game:GetService("ContentProvider");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DJJhaiPartyData = require(ReplicatedStorage.SharedModules.DJJhaiPartyData);
local JandelPartyData = require(ReplicatedStorage.SharedModules.JandelPartyData);

return {
    Start = function(p1) -- Line: 29, Name: Start
        -- upvalues: JandelPartyData (copy), DJJhaiPartyData (copy), ContentProvider (copy)
        task.spawn(function() -- Line: 32
            -- upvalues: JandelPartyData (ref), DJJhaiPartyData (ref), ContentProvider (ref)
            local u2 = {};

            local function queue(p3) -- Line: 35
                -- upvalues: u2 (copy)
                local Animation = Instance.new("Animation");
                Animation.AnimationId = p3;
                table.insert(u2, Animation);
            end;

            local Idle = JandelPartyData.Idle;
            local Animation = Instance.new("Animation");
            Animation.AnimationId = Idle;
            table.insert(u2, Animation);
            local Wave = JandelPartyData.Wave;
            local Animation2 = Instance.new("Animation");
            Animation2.AnimationId = Wave;
            table.insert(u2, Animation2);
            local Talk = JandelPartyData.Talk;
            local Animation3 = Instance.new("Animation");
            Animation3.AnimationId = Talk;
            table.insert(u2, Animation3);

            for _, v in JandelPartyData.Dances do
                local Animation4 = Instance.new("Animation");
                Animation4.AnimationId = v;
                table.insert(u2, Animation4);
            end;

            local Dj = DJJhaiPartyData.Dj;
            local Animation4 = Instance.new("Animation");
            Animation4.AnimationId = Dj;
            table.insert(u2, Animation4);
            local Pose = DJJhaiPartyData.Pose;
            local Animation5 = Instance.new("Animation");
            Animation5.AnimationId = Pose;
            table.insert(u2, Animation5);
            pcall(function() -- Line: 53
                -- upvalues: ContentProvider (ref), u2 (copy)
                ContentProvider:PreloadAsync(u2);
            end);

            for _, v in u2 do
                v:Destroy();
            end;
        end);
    end
};