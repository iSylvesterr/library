-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local Lighting = game:GetService("Lighting");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Workspace = game:GetService("Workspace");
local Audio = require(ReplicatedStorage.Library.Audio);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local CameraShaker = require(ReplicatedStorage.Library.Modules.Packages.CameraShaker);
local EmitDescendants = require(ReplicatedStorage.Library.Functions.EmitDescendants);
local LightningBolt = require(script.Parent.LightningBolt);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
require(script.Types.Interface);
local u1 = Color3.fromRGB(43, 117, 255);
local u2 = Log.new();
local u3 = CameraShaker.new();
local v4 = {};

local function createAttachment(p5) -- Line: 37
    -- upvalues: Workspace (copy), Debris (copy)
    local Attachment = Instance.new("Attachment");
    Attachment.WorldPosition = p5;
    Attachment.Parent = Workspace.Terrain;
    Debris:AddItem(Attachment, 1);

    return Attachment;
end;

local function createBolt(p6, p7, p8) -- Line: 45
    -- upvalues: Workspace (copy), Debris (copy), LightningBolt (copy), u1 (copy)
    local Attachment = Instance.new("Attachment");
    Attachment.WorldPosition = p6 + Vector3.new(0, 400, 0) + p8;
    Attachment.Parent = Workspace.Terrain;
    Debris:AddItem(Attachment, 1);
    local Attachment2 = Instance.new("Attachment");
    Attachment2.WorldPosition = p6;
    Attachment2.Parent = Workspace.Terrain;
    Debris:AddItem(Attachment2, 1);
    local u9 = LightningBolt.new(Attachment, Attachment2, 30);
    u9.Thickness = p7.BoltThickness;
    u9.Color = p7.BoltColor or u1;
    u9.Frequency = 30;
    u9.MinThicknessMultiplier = 0.6;
    u9.MaxThicknessMultiplier = 2.5;
    task.delay(0.7, function() -- Line: 54
        -- upvalues: u9 (copy)
        u9:DestroyDissipate(0.7);
    end);
end;

local function createImpact(p10, p11) -- Line: 59
    -- upvalues: ReplicatedStorage (copy), Workspace (copy), EmitDescendants (copy), Debris (copy), TweenService (copy), Lighting (copy)
    local Assets = ReplicatedStorage.Assets;
    local v12 = Assets:IsA("Folder");
    assert(v12, "ReplicatedStorage.Assets must be a Folder");
    local VFX = Assets.VFX;
    local v13 = VFX:IsA("Folder");
    assert(v13, "ReplicatedStorage.Assets.VFX must be a Folder");
    local LightningStrike = VFX.LightningStrike;
    local v14 = LightningStrike:IsA("Folder");
    assert(v14, "ReplicatedStorage.Assets.VFX.LightningStrike must be a Folder");
    local fx = LightningStrike.fx;
    local v15 = fx:IsA("BasePart");
    assert(v15, "LightningStrike.fx must be a BasePart");
    local v16 = fx:Clone();
    v16.CFrame = p10;
    v16.Parent = Workspace.__DEBRIS;
    EmitDescendants(v16);
    Debris:AddItem(v16, 2);
    local PointLight = Instance.new("PointLight");
    PointLight.Color = Color3.fromRGB(82, 122, 255);
    PointLight.Range = p11.ImpactLightRange;
    PointLight.Brightness = p11.ImpactLightBrightness;
    PointLight.Parent = v16;
    TweenService:Create(PointLight, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        Brightness = 0,
        Range = 0
    }):Play();
    Debris:AddItem(PointLight, 0.35);
    local LightningStrikeBlackout = script.LightningStrikeBlackout;
    local v17 = LightningStrikeBlackout:IsA("ColorCorrectionEffect");
    assert(v17, "LightningStrikeBlackout must be a ColorCorrectionEffect");
    local v18 = LightningStrikeBlackout:Clone();
    v18.Parent = Lighting;
    Debris:AddItem(v18, p11.FlashDuration);
end;

function v4.Play(u19, u20) -- Line: 96
    -- upvalues: Asserts (copy), createBolt (copy), createImpact (copy), Audio (copy), u3 (copy), u2 (copy)
    Asserts.CFrame(u19);
    createBolt(u19.Position, u20, Vector3.new(0, 0, 0));

    if u20.SecondaryBolt then
        createBolt(u19.Position, u20, Vector3.new(11, 0, -9));
    end;

    task.delay(0.65, function() -- Line: 102
        -- upvalues: createImpact (ref), u19 (copy), u20 (copy), Audio (ref), u3 (ref), u2 (ref)
        createImpact(u19, u20);
        Audio.Play(128966102518500, u19, 1, 0.8, 350);
        Audio.Play(107651969389508, script, 1, 0.3);
        u3:ShakeOnce(u20.CameraShakeMagnitude, 10, 0, 0.75);
        u2:AtDebug():Log("Lightning strike impact played");
    end);
end;

u3:Start();

return table.freeze(v4);