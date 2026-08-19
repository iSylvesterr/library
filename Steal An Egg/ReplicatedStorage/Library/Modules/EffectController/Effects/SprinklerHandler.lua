-- Decompiled with Potassium's decompiler.

local Workspace = game:GetService("Workspace");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
require(script.Parent.Parent.Types);
local Gears = require(ReplicatedStorage.Directory.Gears);
require(ReplicatedStorage.Library.Types.Tools);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Easing = require(ReplicatedStorage.Library.Functions.Easing);
local Audio = require(ReplicatedStorage.Library.Audio);
local Sprinklers = ReplicatedStorage.Assets.Sprinklers;
local Sprinklers2 = Workspace:FindFirstChild("Sprinklers");

if not Sprinklers2 then
    Sprinklers2 = Instance.new("Folder");
    assert(Sprinklers2, "luau");
    Sprinklers2.Name = "Sprinklers";
    Sprinklers2.Parent = Workspace;
end;

for _, v in pairs(Gears.Directory) do
    if v.IsSprinkler then
        local v1 = Sprinklers:FindFirstChild((`{v._id} VFX`));

        if Constants.IS_STUDIO then
            local v2 = `Gear vfx not found for sprinkler: "{v._id}"`;
            assert(v1, v2);
            local v3 = ReplicatedStorage.ObjectModels:FindFirstChild(v._id);
            local v4 = `Gear model not found for sprinkler: "{v._id}"`;
            assert(v3, v4);
        end;

        if v1 then
            local ControllerData = v.ControllerData;
            v1.Size = Vector3.new(ControllerData.Radius, v1.Size.Y, ControllerData.Radius);
        end;
    end;
end;

local u5 = {};
local u6 = table.create(15);
local u7 = table.create(15);
local u8 = nil;

local function elasticOut(p9) -- Line: 64
    -- upvalues: Easing (copy)
    return Easing(p9, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out);
end;

local function jellyAngles(p10, p11, p12, p13, p14, p15) -- Line: 68
    if p12 < p10.PrevPhase then
        p10.WobbleStart = p11;
    end;

    p10.PrevPhase = p12;
    local v16 = p11 - p10.WobbleStart;
    local v17 = (p13 - p14) / math.max(p15, 0.004166666666666667);
    local v18 = math.abs(v17) / 2.8;
    local v19 = math.clamp(v18, 0, 1) * 0.10471975511965978 * math.exp(v16 * -2.2) * math.sin(37.69911184307752 * v16);

    return v19, 0, -v19;
end;

local function step(p20) -- Line: 89
    -- upvalues: u6 (copy), u7 (copy), u5 (ref), Easing (copy), Workspace (copy), u8 (ref)
    local v21 = os.clock();
    table.clear(u6);
    table.clear(u7);

    for i, v in pairs(u5) do
        if v.Part.Parent then
            u6[#u6 + 1] = v.Part;
            local v22 = (v21 - v.Start) / 1 % 1;
            local v23;

            if v22 < 0.5 then
                v23 = math.sin(v22 * 2 * 3.141592653589793 / 2) * 1.4;
            else
                v23 = (1 - Easing((v22 - 0.5) * 2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)) * 1.4;
            end;

            local LastOffset = v.LastOffset;

            if v22 < v.PrevPhase then
                v.WobbleStart = v21;
            end;

            v.PrevPhase = v22;
            local v24 = v21 - v.WobbleStart;
            local v25 = (v23 - LastOffset) / math.max(p20, 0.004166666666666667);
            local v26 = math.abs(v25) / 2.8;
            local v27 = math.clamp(v26, 0, 1) * 0.10471975511965978 * math.exp(v24 * -2.2) * math.sin(37.69911184307752 * v24);
            v.LastOffset = v23;
            u7[#u7 + 1] = v.BaseCFrame * CFrame.new(0, -v23, 0) * CFrame.Angles(v27, 0, -v27);
        else
            u5[i] = nil;
        end;
    end;

    if #u6 > 0 then
        Workspace:BulkMoveTo(u6, u7, Enum.BulkMoveMode.FireCFrameChanged);
    end;

    if u8 and next(u5) == nil then
        u8:Disconnect();
        u8 = nil;
    end;
end;

local function startStepping() -- Line: 129
    -- upvalues: u8 (ref), RunService (copy), step (copy)
    if not u8 then
        u8 = RunService.RenderStepped:Connect(step);
    end;
end;

local function addBounce(p28, p29, p30) -- Line: 135
    -- upvalues: u5 (ref), u8 (ref), RunService (copy), step (copy)
    u5[p28] = {
        PrevPhase = 0,
        LastOffset = 0,
        Part = p29,
        BaseCFrame = p30,
        Start = os.clock(),
        WobbleStart = os.clock()
    };

    if not u8 then
        u8 = RunService.RenderStepped:Connect(step);
    end;
end;

local function removeBounce(p31) -- Line: 141
    -- upvalues: u5 (ref), u8 (ref)
    u5[p31] = nil;

    if u8 and next(u5) == nil then
        u8:Disconnect();
        u8 = nil;
    end;
end;

return {
    Create = function(u32) -- Line: 150, Name: Create
        -- upvalues: ReplicatedStorage (copy), Gears (copy), Sprinklers2 (ref), Sprinklers (copy), Audio (copy), addBounce (copy)
        local ID = u32.Parameters.ID;
        local SprinklerType = u32.Parameters.SprinklerType;
        local u33 = u32.Parameters.SprinklerCFrame * CFrame.Angles(0, 3.141592653589793, 3.141592653589793);
        local v34 = ReplicatedStorage.ObjectModels:FindFirstChild(SprinklerType);

        if not v34 then
            return;
        end;

        local u35 = Gears.Directory[SprinklerType];

        if u35 then
            u35 = u35.ControllerData;
        end;

        if not u35 then
            return;
        end;

        local u36 = v34:Clone();
        u36:SetAttribute("EndTime", u32.Parameters.EndTime);
        u36.PrimaryPart.CFrame = u33 * CFrame.new(0, 1, 0);
        u36.Parent = Sprinklers2;
        local v37 = u32.Default:CreateEffect({
            Emit = true,
            DebrisTime = 2,
            Object = Sprinklers.PlaceEffect,
            Position = u33
        });

        if u35.PlaceSFX then
            Audio.PlayFromSoundFile(u35.PlaceSFX, u33);
        else
            u32.Default:PlaySound(Sprinklers.PlaceSFX, v37);
        end;

        u32.Libraries.BoatTween:Create(u36.PrimaryPart, {
            Time = 0.8,
            EasingStyle = "Smoother",
            EasingDirection = "In",
            StepType = "Heartbeat",
            Goal = {
                CFrame = u33 * u35.Offset
            }
        }):Play();
        u32.Cache[ID] = {
            Sprinkler = u36,
            SprinklerCFrame = u33,
            ControllerData = u35
        };

        if u35.BounceAnimate then
            task.delay(1, function() -- Line: 203
                -- upvalues: u36 (copy), addBounce (ref), ID (copy), u33 (copy), u35 (copy)
                if not (u36 and (u36.PrimaryPart and u36.Parent)) then
                    return;
                end;

                addBounce(ID, u36.PrimaryPart, u33 * u35.Offset);
            end);
        end;

        task.spawn(function() -- Line: 210
            -- upvalues: u32 (copy), Sprinklers (ref), SprinklerType (copy), u36 (copy), u33 (copy), u35 (copy), ID (copy), Audio (ref)
            local v38 = u32.Default:CreateEffect({
                Object = Sprinklers[string.format("%s VFX", SprinklerType)],
                Parent = u36,
                Position = CFrame.new((u33 * u35.Offset).Position)
            });
            u32.Cache[ID].SprinklerEffect = v38;
            local v39;

            if u35.LoopSFX then
                v39 = Audio.PlayFromSoundFile(u35.LoopSFX, u33);
                v39.Parent = v38;
            else
                v39 = u32.Default:PlaySound(Sprinklers.SprinklerLoop, v38);
            end;

            u32.Cache[ID].LoopSound = v39;

            while u36 and u36.Parent do
                local v40 = u35.WaitTime * 100;
                task.wait(math.random(math.floor(v40 / 3), v40) / 100);
            end;
        end);
    end,

    Destroy = function(p41) -- Line: 231, Name: Destroy
        -- upvalues: u5 (ref), u8 (ref), Audio (copy), Sprinklers (copy)
        local ID = p41.Parameters.ID;
        local v42 = p41.Cache[ID];

        if typeof(v42) ~= "table" then
            return;
        end;

        local Sprinkler = v42.Sprinkler;

        if not Sprinkler then
            return;
        end;

        local SprinklerEffect = v42.SprinklerEffect;

        if SprinklerEffect then
            p41.Default:UpdateStatus(SprinklerEffect, false, {});
        end;

        local LoopSound = v42.LoopSound;

        if LoopSound then
            LoopSound:Destroy();
        end;

        u5[ID] = nil;

        if u8 and next(u5) == nil then
            u8:Disconnect();
            u8 = nil;
        end;

        local v43 = v42.SprinklerCFrame or p41.Parameters.SprinklerCFrame;
        local ControllerData = v42.ControllerData;

        if ControllerData and ControllerData.DespawnSFX then
            Audio.PlayFromSoundFile(ControllerData.DespawnSFX, Sprinkler);
        else
            p41.Default:PlaySound(Sprinklers.DespawnSFX, Sprinkler);
        end;

        p41.Libraries.BoatTween:Create(Sprinkler.PrimaryPart, {
            Time = 0.6,
            EasingStyle = "ExitExpressive",
            EasingDirection = "In",
            StepType = "Heartbeat",
            Goal = {
                CFrame = v43 * CFrame.new(0, 3, 0)
            }
        }):Play();
        task.delay(0.6, function() -- Line: 268
            -- upvalues: Sprinkler (copy)
            if Sprinkler then
                Sprinkler:Destroy();
            end;
        end);
        p41.Cache[ID] = nil;
    end,

    Cancel = function(p44) -- Line: 275, Name: Cancel
        -- upvalues: u5 (ref), u8 (ref)
        for _, v in pairs(p44.Cache) do
            if v then
                local v = v.LoopSound;
            end;

            if v then
                v:Destroy();
            end;
        end;

        p44.Container:Clean();
        p44.Cache = {};
        u5 = {};

        if u8 then
            u8:Disconnect();
            u8 = nil;
        end;
    end
};