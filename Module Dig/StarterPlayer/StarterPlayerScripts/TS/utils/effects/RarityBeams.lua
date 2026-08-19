-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local ReplicatedStorage = v1.ReplicatedStorage;
local RunService = v1.RunService;
local Workspace = v1.Workspace;
local v2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "ui", "RarityStyles");
local rarityStyleFor = v2.rarityStyleFor;
local rarityTierIndex = v2.rarityTierIndex;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u3 = { {
        key = "Pop",
        playbackSpeed = 1
    }, {
        key = "BeamGreen",
        playbackSpeed = 1.2
    }, {
        key = "BeamBlue",
        playbackSpeed = 1
    }, {
        key = "BeamPurple",
        playbackSpeed = 1
    }, {
        key = "BeamGold",
        playbackSpeed = 1
    }, {
        key = "BeamMythic",
        playbackSpeed = 1.25
    }, {
        key = "BeamDivine",
        playbackSpeed = 1
    }, {
        key = "BeamEternal",
        playbackSpeed = 1.15
    }, {
        key = "BeamTranscendent",
        playbackSpeed = 1.3
    } };

local function saturate(p4) -- Line: 57
    local v5, v6, v7 = p4:ToHSV();

    if v6 == 0 then
        return p4;
    end;

    return Color3.fromHSV(v5, math.min(v6 * 1.6 + 0.08, 1), v7);
end;

local function saturateSequence(p8) -- Line: 64
    -- upvalues: saturate (copy)
    local Keypoints = p8.Keypoints;
    local v9 = table.create(#Keypoints);

    local function _(p10) -- Line: 68
        -- upvalues: saturate (ref)
        return ColorSequenceKeypoint.new(p10.Time, saturate(p10.Value));
    end;

    for i, v in Keypoints do
        local _ = i - 1;
        v9[i] = ColorSequenceKeypoint.new(v.Time, saturate(v.Value));
    end;

    return ColorSequence.new(v9);
end;

local u11 = {
    {
        minBeams = 2,
        maxBeams = 3,
        minHeight = 5,
        maxHeight = 8,
        minWidth = 1.2,
        maxWidth = 1.8,
        brightness = 0.6
    },
    {
        minBeams = 3,
        maxBeams = 5,
        minHeight = 8,
        maxHeight = 12,
        minWidth = 1.5,
        maxWidth = 2.3,
        brightness = 0.85
    },
    {
        minBeams = 4,
        maxBeams = 6,
        minHeight = 10,
        maxHeight = 14,
        minWidth = 1.7,
        maxWidth = 2.6,
        brightness = 1
    },
    {
        minBeams = 5,
        maxBeams = 7,
        minHeight = 12,
        maxHeight = 17,
        minWidth = 2,
        maxWidth = 3,
        brightness = 1.15
    },
    {
        minBeams = 6,
        maxBeams = 8,
        minHeight = 14,
        maxHeight = 20,
        minWidth = 2.4,
        maxWidth = 3.6,
        brightness = 1.3
    },
    {
        minBeams = 7,
        maxBeams = 9,
        minHeight = 17,
        maxHeight = 24,
        minWidth = 2.8,
        maxWidth = 4.2,
        brightness = 1.5
    },
    {
        minBeams = 8,
        maxBeams = 11,
        minHeight = 20,
        maxHeight = 28,
        minWidth = 3.4,
        maxWidth = 5,
        brightness = 1.7
    },
    {
        minBeams = 10,
        maxBeams = 13,
        minHeight = 24,
        maxHeight = 34,
        minWidth = 4,
        maxWidth = 6,
        brightness = 1.95
    },
    {
        minBeams = 12,
        maxBeams = 16,
        minHeight = 29,
        maxHeight = 41,
        minWidth = 4.8,
        maxWidth = 7.2,
        brightness = 2.25
    }
};

return {
    RarityBeams = {
        beamSound = function(p12) -- Line: 153, Name: beamSound
            -- upvalues: u3 (copy), rarityTierIndex (copy)
            return u3[rarityTierIndex(p12) + 1];
        end,

        create = function(p13, p14, p15, p16) -- Line: 157, Name: create
            -- upvalues: WFChain (copy), ReplicatedStorage (copy), rarityTierIndex (copy), rarityStyleFor (copy), u11 (copy), saturateSequence (copy), Workspace (copy), RunService (copy)
            local v17 = WFChain(ReplicatedStorage, "Assets", "RarityBeam");
            local v18 = rarityTierIndex(p14);
            local v19 = rarityStyleFor(p14);
            local u20 = u11[v18 + 1];
            local v21 = (math.max(p15.X, p15.Y, p15.Z) / 2) ^ 0.6;
            local v22 = math.clamp(v21, 0.8, 2.2);
            local v23;

            if v18 >= 4 then
                v23 = v19.gradient;
            else
                v23 = nil;
            end;

            local v24;

            if v23 then
                v24 = saturateSequence(v23);
            else
                v24 = nil;
            end;

            local color = v19.color;
            local v25, v26, v27 = color:ToHSV();

            if v26 ~= 0 then
                color = Color3.fromHSV(v25, math.min(v26 * 1.6 + 0.08, 1), v27);
            end;

            local Part = Instance.new("Part");
            Part.Name = "RarityBeams";
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.CanQuery = false;
            Part.CanTouch = false;
            Part.CastShadow = false;
            Part.Transparency = 1;
            Part.Size = Vector3.new(1, 1, 1);
            Part.CFrame = CFrame.new(p13);
            Part.Parent = Workspace;
            p16:Add(Part, "Destroy");
            local v28 = math.random(u20.minBeams, u20.maxBeams);
            local v29 = os.clock();
            local v30 = false;
            local v31 = 0;
            local u32 = {};

            while true do
                if v30 then
                    v31 = v31 + 1;
                else
                    v30 = true;
                end;

                if v31 >= v28 then
                    local u33 = nil;
                    local u34 = nil;
                    u34 = RunService.Heartbeat:Connect(function() -- Line: 237
                        -- upvalues: u33 (ref), u34 (ref), Part (copy), u32 (copy), u20 (copy)
                        local v35 = os.clock();
                        local v36;

                        if u33 == nil then
                            v36 = 1;
                        else
                            local v37 = math.clamp((v35 - u33) / 0.55, 0, 1);

                            if v37 >= 1 then
                                u34:Disconnect();
                                Part:Destroy();

                                return nil;
                            end;

                            v36 = 1 - v37 * v37;
                        end;

                        for _, v in u32 do
                            local v38 = (1 - (1 - math.clamp((v35 - v.emergeStart) / v.emergeDuration, 0, 1)) ^ 3) * v36;
                            local v39 = math.sin(v35 * v.swayFrequency + v.swayPhase);
                            local v40 = math.cos(v35 * v.swayFrequency * 0.83 + v.swayPhase);
                            local v41 = Vector3.new(v39, 0, v40) * (v.swayAmplitude * v38);
                            v.tip.Position = v.basePosition + v.direction * (v.height * v38) + v41;
                            local v42 = math.sin(v35 * v.pulseFrequency + v.pulsePhase) * 0.14 + 1;
                            v.beam.Width0 = v38 * 0.3;
                            v.beam.Width1 = v.width * v38 * v42;
                            local v43 = math.sin(v35 * v.flickerFrequency + v.flickerPhase) * 0.28 * math.sin(v35 * v.flickerFrequency * 1.71 + v.flickerPhase * 1.37) + 0.72;
                            v.beam.Brightness = u20.brightness * v43;
                        end;
                    end);
                    p16:Add(u34, "Disconnect");

                    return {
                        anchor = Part,

                        fadeOut = function(p44) -- Line: 270, Name: fadeOut
                            -- upvalues: u33 (ref)
                            if u33 == nil then
                                u33 = os.clock();
                            end;
                        end
                    };
                end;

                local v45 = math.random() * 3.141592653589793 * 2;
                local v46 = math.random();
                local v47 = v22 * 1.3 * math.sqrt(v46);
                local v48 = math.cos(v45) * v47;
                local v49 = math.sin(v45) * v47;
                local v50 = Vector3.new(v48, -0.2, v49);
                local Attachment = Instance.new("Attachment");
                Attachment.Position = v50;
                Attachment.Parent = Part;
                local Attachment2 = Instance.new("Attachment");
                Attachment2.Position = v50;
                Attachment2.Parent = Part;
                local v51 = v17:Clone();
                v51.Attachment0 = Attachment;
                v51.Attachment1 = Attachment2;
                v51.Color = v24 or ColorSequence.new(color:Lerp(v19.color, math.random() * 0.3));
                v51.Width0 = 0;
                v51.Width1 = 0;
                v51.LightEmission = 0.75;
                v51.Brightness = u20.brightness;
                v51.Enabled = true;
                v51.Parent = Part;
                local v52 = math.random() * 0.3839724354387525;
                local v53 = math.random() * 3.141592653589793 * 2;
                local v54 = {
                    beam = v51,
                    tip = Attachment2,
                    basePosition = v50
                };
                local v55 = math.sin(v52) * math.cos(v53);
                local v56 = math.cos(v52);
                local v57 = math.sin(v52) * math.sin(v53);
                v54.direction = Vector3.new(v55, v56, v57);
                v54.height = (u20.minHeight + math.random() * (u20.maxHeight - u20.minHeight)) * v22;
                v54.width = (u20.minWidth + math.random() * (u20.maxWidth - u20.minWidth)) * v22;
                v54.emergeStart = v29 + math.random() * 0.35;
                v54.emergeDuration = 0.45 + math.random() * 0.3;
                v54.swayPhase = math.random() * 3.141592653589793 * 2;
                v54.swayFrequency = 0.6 + math.random() * 0.8;
                v54.swayAmplitude = 0.15 + math.random() * 0.3;
                v54.pulsePhase = math.random() * 3.141592653589793 * 2;
                v54.pulseFrequency = 2 + math.random() * 2;
                v54.flickerPhase = math.random() * 3.141592653589793 * 2;
                v54.flickerFrequency = 6 + math.random() * 5;
                table.insert(u32, v54);
            end;
        end
    }
};