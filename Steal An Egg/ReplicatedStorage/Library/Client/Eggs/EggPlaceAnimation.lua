-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local EggActionMovement = require(script.Parent.EggActionMovement);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u2 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u3 = TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out);
local u4 = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
local u5 = TweenInfo.new(0.12, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out);
local u6 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u7 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
local u8 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u9 = {
    Color3.fromRGB(101, 67, 33),
    Color3.fromRGB(92, 60, 28),
    Color3.fromRGB(110, 75, 40),
    Color3.fromRGB(85, 55, 25)
};
local u32 = {
    CreateDirtChunk = function(p10, p11, p12) -- Line: 41, Name: CreateDirtChunk
        -- upvalues: Asserts (copy), u9 (copy), TweenService (copy), u4 (copy), u5 (copy), u6 (copy), u7 (copy), Debris (copy)
        Asserts.Instance(p10);
        Asserts.Vector3(p11);
        Asserts.number(p12);
        local Part = Instance.new("Part");
        local u13 = math.random(25, 45) / 100 * p12;
        Part.Size = Vector3.new(u13, u13 * 0.7, u13);
        Part.Color = u9[math.random(1, #u9)];
        Part.Material = Enum.Material.SmoothPlastic;
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CastShadow = false;
        Part.Transparency = 0;
        Part.Position = p11 + Vector3.new(0, 0.05, 0);
        local v14 = math.random(-30, 30);
        local v15 = math.random(-180, 180);
        Part.Orientation = Vector3.new(v14, v15, math.random(-30, 30));
        Part.Parent = p10;
        local v16 = math.random(0, 360);
        local v17 = math.rad(v16);
        local v18 = math.random(30, 60) / 100 * p12;
        local v19 = math.cos(v17) * v18;
        local v20 = math.sin(v17) * v18;
        local v21 = math.random(50, 90) / 100 * p12;
        local v22 = p11 + Vector3.new(v19 * 0.6, v21, v20 * 0.6);
        local u23 = p11 + Vector3.new(v19, p12 * 0.02, v20);
        local u24 = u23 + Vector3.new(0, p12 * -0.01, 0);
        local v25 = {
            Position = v22
        };
        local Orientation = Part.Orientation;
        local v26 = math.random(-45, 45);
        local v27 = math.random(-90, 90);
        v25.Orientation = Orientation + Vector3.new(v26, v27, math.random(-45, 45));
        local v28 = TweenService:Create(Part, u4, v25);
        v28:Play();
        v28.Completed:Once(function() -- Line: 71
            -- upvalues: TweenService (ref), Part (copy), u5 (ref), u23 (copy), u13 (copy), u6 (ref), u24 (copy), u7 (ref), Debris (ref)
            local v29 = TweenService:Create(Part, u5, {
                Position = u23,
                Size = Vector3.new(u13 * 1.1, u13 * 0.5, u13 * 1.1)
            });
            v29:Play();
            v29.Completed:Once(function() -- Line: 77
                -- upvalues: TweenService (ref), Part (ref), u6 (ref), u24 (ref), u13 (ref), u7 (ref), Debris (ref)
                local v30 = TweenService:Create(Part, u6, {
                    Position = u24,
                    Size = Vector3.new(u13, u13 * 0.65, u13)
                });
                v30:Play();
                v30.Completed:Once(function() -- Line: 83
                    -- upvalues: TweenService (ref), Part (ref), u7 (ref), Debris (ref)
                    task.delay(0.15, function() -- Line: 84
                        -- upvalues: TweenService (ref), Part (ref), u7 (ref), Debris (ref)
                        TweenService:Create(Part, u7, {
                            Transparency = 1
                        }):Play();
                        Debris:AddItem(Part, u7.Time);
                    end);
                end);
            end);
        end);
    end,

    PlaySfx = function(p31) -- Line: 95, Name: PlaySfx
        -- upvalues: Asserts (copy), Debris (copy)
        Asserts.Instance(p31);
        local Sound = Instance.new("Sound");
        Sound.SoundId = "rbxassetid://74146265484496";
        Sound.PlaybackSpeed = 1 + math.random(-10, 10) / 100;
        Sound.Parent = p31;
        Sound:Play();
        Sound.Ended:Once(function() -- Line: 103
            -- upvalues: Sound (copy)
            Sound:Destroy();
        end);
        Debris:AddItem(Sound, 5);
    end
};

function u32.SpawnDirtChunks(u33, u34, u35) -- Line: 109
    -- upvalues: Asserts (copy), u32 (copy)
    Asserts.Instance(u33);
    Asserts.Vector3(u34);
    Asserts.number(u35);
    local v36 = math.random(6, 10);
    u32.CreateDirtChunk(u33, u34, u35);

    for i = 2, v36 do
        task.delay((i - 1) * 0.015, function() -- Line: 117
            -- upvalues: u32 (ref), u33 (copy), u34 (copy), u35 (copy)
            u32.CreateDirtChunk(u33, u34, u35);
        end);
    end;
end;

function u32.CreateDirtDecal(p37, p38, p39) -- Line: 123
    -- upvalues: Asserts (copy), TweenService (copy), u1 (copy), u2 (copy), Debris (copy)
    Asserts.Instance(p37);
    Asserts.Vector3(p38);
    Asserts.number(p39);
    local u40 = p39 * 0.1;
    local v41 = p39 * 0.8;
    local v42 = p39 * 1.6;
    local u43 = p39 * 1.4000000000000001;
    local Part = Instance.new("Part");
    Part.Name = "EggPlaceDirtDecal";
    Part.Shape = Enum.PartType.Cylinder;
    Part.Size = Vector3.new(u40, v41, v41);
    Part.Color = Color3.fromRGB(101, 67, 33);
    Part.Material = Enum.Material.SmoothPlastic;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CastShadow = false;
    Part.Transparency = 1;
    Part.Position = p38 - Vector3.new(0, 0.01, 0);
    local v44 = math.random(-180, 180);
    Part.Orientation = Vector3.new(0, v44, 90);
    Part.Parent = p37;
    TweenService:Create(Part, u1, {
        Transparency = 0,
        Size = Vector3.new(u40, v42, v42)
    }):Play();
    task.delay(math.random(7, 11), function() -- Line: 149
        -- upvalues: TweenService (ref), Part (copy), u2 (ref), u40 (copy), u43 (copy), Debris (ref)
        TweenService:Create(Part, u2, {
            Transparency = 1,
            Size = Vector3.new(u40, u43, u43)
        }):Play();
        Debris:AddItem(Part, u2.Time);
    end);
end;

function u32.CreateImpactRing(p45, p46, p47) -- Line: 158
    -- upvalues: Asserts (copy), TweenService (copy), u8 (copy), Debris (copy)
    Asserts.Instance(p45);
    Asserts.Vector3(p46);
    Asserts.number(p47);
    local Part = Instance.new("Part");
    Part.Name = "EggPlaceImpactRing";
    Part.Shape = Enum.PartType.Cylinder;
    Part.Size = Vector3.new(p47 * 0.05, p47 * 0.3, p47 * 0.3);
    Part.Color = Color3.fromRGB(139, 90, 43);
    Part.Material = Enum.Material.SmoothPlastic;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CastShadow = false;
    Part.Transparency = 0.3;
    Part.Position = p46 + Vector3.new(0, 0.02, 0);
    Part.Orientation = Vector3.new(0, 0, 90);
    Part.Parent = p45;
    TweenService:Create(Part, u8, {
        Transparency = 1,
        Size = Vector3.new(p47 * 0.05, p47 * 1.8, p47 * 1.8)
    }):Play();
    Debris:AddItem(Part, 0.35);
end;

function u32.Play(u48, u49, u50) -- Line: 183
    -- upvalues: Asserts (copy), EggActionMovement (copy), Trove (copy), u32 (copy), TweenService (copy), u3 (copy)
    Asserts.Model(u48);
    Asserts.CFrame(u49);
    Asserts.Instance(u50);
    local PrimaryPart = u48.PrimaryPart;
    Asserts.BasePart(PrimaryPart);
    local v51 = math.min(PrimaryPart.Size.X, PrimaryPart.Size.Y, PrimaryPart.Size.Z);
    local u52 = math.max(v51, 0.1);
    local Position = u49.Position;
    local u53 = u49.Position.Y + PrimaryPart.Size.Y * 0.1;
    local u54 = false;
    local v55 = u49 + Vector3.new(0, PrimaryPart.Size.Y * 2, 0);
    local CFrameValue = Instance.new("CFrameValue");
    CFrameValue.Value = v55;
    EggActionMovement.SetPivot(u48, v55);
    local u56 = Trove.new();
    u56:Add(CFrameValue);

    local function startImpactEffects() -- Line: 203
        -- upvalues: u54 (ref), u32 (ref), u50 (copy), Position (copy), u52 (copy)
        if u54 then
            return;
        end;

        u54 = true;
        u32.PlaySfx(u50);
        u32.SpawnDirtChunks(u50, Position, u52);
        u32.CreateDirtDecal(u50, Position, u52);
        u32.CreateImpactRing(u50, Position, u52);
    end;

    u56:Add(CFrameValue:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 215
        -- upvalues: EggActionMovement (ref), u48 (copy), CFrameValue (copy), u53 (copy), startImpactEffects (copy)
        EggActionMovement.SetPivot(u48, CFrameValue.Value);

        if CFrameValue.Value.Position.Y <= u53 then
            startImpactEffects();
        end;
    end));
    local v57 = TweenService:Create(CFrameValue, u3, {
        Value = u49
    });
    v57:Play();
    v57.Completed:Once(function() -- Line: 226
        -- upvalues: EggActionMovement (ref), u48 (copy), u49 (copy), startImpactEffects (copy), u56 (copy)
        EggActionMovement.SetPivot(u48, u49);
        startImpactEffects();
        u56:Destroy();
    end);
end;

return u32;