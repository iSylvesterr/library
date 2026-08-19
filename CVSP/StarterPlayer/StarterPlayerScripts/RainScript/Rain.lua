-- Decompiled with Potassium's decompiler.

local v1 = Color3.new(1, 1, 1);
local v2 = NumberSequence.new(10);
local v3 = NumberRange.new(0.8);
local v4 = NumberSequence.new({ NumberSequenceKeypoint.new(0, 5.33, 2.75), NumberSequenceKeypoint.new(1, 5.33, 2.75) });
local v5 = NumberRange.new(0.8);
local v6 = NumberRange.new(0, 360);
local v7 = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.4, 3), NumberSequenceKeypoint.new(1, 0) });
local v8 = NumberRange.new(0.1, 0.15);
local v9 = NumberRange.new(0, 360);
local v10 = Vector2.new(10, 10);
local u11 = {
    None = 0,
    Whitelist = 1,
    Blacklist = 2,
    Function = 3
};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local NumberValue = Instance.new("NumberValue");
NumberValue.Value = 1;
local None = u11.None;
local new = Vector3.new;
local u12 = NumberSequenceKeypoint.new(0, 1, 0);
local u13 = NumberSequenceKeypoint.new(1, 1, 0);
local u14 = {};
local u15 = 0;
local u16 = 1;
local u17 = 0;
local u18 = Vector3.new(0, -1, 0);
local u19 = nil;
local u20 = nil;
local u21 = {};
local u22 = 1;
local u23 = 0;
local u24 = true;
local u25 = nil;

for _, v in pairs({
    Vector3.new(0.14142136, 0, 0.14142136),
    Vector3.new(-0.14142136, 0, 0.14142136),
    Vector3.new(-0.14142136, 0, -0.14142136),
    Vector3.new(0.14142136, 0, -0.14142136),
    Vector3.new(0.4, 0, 0),
    Vector3.new(0.28284273, 0, 0.28284273),
    Vector3.new(0.000000000000000024492937, 0, 0.4),
    Vector3.new(-0.28284273, 0, 0.28284273),
    Vector3.new(-0.4, 0, 0.000000000000000048985874),
    Vector3.new(-0.28284273, 0, -0.28284273),
    Vector3.new(-0.000000000000000073478805, 0, -0.4),
    Vector3.new(0.28284273, 0, -0.28284273),
    Vector3.new(0.6, 0, 0),
    Vector3.new(0.4854102, 0, 0.35267115),
    Vector3.new(0.1854102, 0, 0.57063395),
    Vector3.new(-0.1854102, 0, 0.57063395),
    Vector3.new(-0.4854102, 0, 0.35267115),
    Vector3.new(-0.6, 0, 0.00000000000000007347881),
    Vector3.new(-0.4854102, 0, -0.35267115),
    Vector3.new(-0.1854102, 0, -0.57063395),
    Vector3.new(0.1854102, 0, -0.57063395),
    Vector3.new(0.4854102, 0, -0.35267115),
    Vector3.new(0.77274066, 0, 0.20705524),
    Vector3.new(0.56568545, 0, 0.56568545),
    Vector3.new(0.20705524, 0, 0.77274066),
    Vector3.new(-0.20705524, 0, 0.77274066),
    Vector3.new(-0.56568545, 0, 0.56568545),
    Vector3.new(-0.77274066, 0, 0.20705524),
    Vector3.new(-0.77274066, 0, -0.20705524),
    Vector3.new(-0.56568545, 0, -0.56568545),
    Vector3.new(-0.20705524, 0, -0.77274066),
    Vector3.new(0.20705524, 0, -0.77274066),
    Vector3.new(0.56568545, 0, -0.56568545),
    Vector3.new(0.77274066, 0, -0.20705524)
}) do
    table.insert(u14, v * 35);
end;

table.sort(u14, function(p26, p27) -- Line: 269
    return p26.magnitude < p27.magnitude;
end);
local SoundGroup = Instance.new("SoundGroup");
SoundGroup.Name = "__RainSoundGroup";
SoundGroup.Volume = 0.2;
SoundGroup.Archivable = false;
local Sound = Instance.new("Sound");
Sound.Name = "RainSound";
Sound.Volume = u15;
Sound.SoundId = "rbxassetid://1516791621";
Sound.Looped = true;
Sound.SoundGroup = SoundGroup;
Sound.Parent = SoundGroup;
Sound.Archivable = false;
local Part = Instance.new("Part");
Part.Transparency = 1;
Part.Anchored = true;
Part.CanCollide = false;
Part.Locked = false;
Part.Archivable = false;
Part.TopSurface = Enum.SurfaceType.Smooth;
Part.BottomSurface = Enum.SurfaceType.Smooth;
Part.Name = "__RainEmitter";
Part.Size = Vector3.new(0.05, 0.05, 0.05);
Part.Archivable = false;
local ParticleEmitter = Instance.new("ParticleEmitter");
ParticleEmitter.Name = "RainStraight";
ParticleEmitter.LightEmission = 0.05;
ParticleEmitter.LightInfluence = 0.9;
ParticleEmitter.Size = v2;
ParticleEmitter.Texture = "rbxassetid://1822883048";
ParticleEmitter.LockedToPart = true;
ParticleEmitter.Enabled = false;
ParticleEmitter.Lifetime = v3;
ParticleEmitter.Rate = 600;
ParticleEmitter.Speed = NumberRange.new(60);
ParticleEmitter.EmissionDirection = Enum.NormalId.Bottom;
ParticleEmitter.Parent = Part;
ParticleEmitter.Orientation = Enum.ParticleOrientation.FacingCameraWorldUp;
local ParticleEmitter2 = Instance.new("ParticleEmitter");
ParticleEmitter2.Name = "RainTopDown";
ParticleEmitter2.LightEmission = 0.05;
ParticleEmitter2.LightInfluence = 0.9;
ParticleEmitter2.Size = v4;
ParticleEmitter2.Texture = "rbxassetid://1822856633";
ParticleEmitter2.LockedToPart = true;
ParticleEmitter2.Enabled = false;
ParticleEmitter2.Rotation = v6;
ParticleEmitter2.Lifetime = v5;
ParticleEmitter2.Rate = 600;
ParticleEmitter2.Speed = NumberRange.new(60);
ParticleEmitter2.EmissionDirection = Enum.NormalId.Bottom;
ParticleEmitter2.Parent = Part;
local u28 = {};
local u29 = {};

for _ = 1, 20 do
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "__RainSplashAttachment";
    local ParticleEmitter3 = Instance.new("ParticleEmitter");
    ParticleEmitter3.LightEmission = 0.05;
    ParticleEmitter3.LightInfluence = 0.9;
    ParticleEmitter3.Size = v7;
    ParticleEmitter3.Texture = "rbxassetid://1822856633";
    ParticleEmitter3.Rotation = v9;
    ParticleEmitter3.Lifetime = v8;
    ParticleEmitter3.Transparency = NumberSequence.new({
        u12,
        NumberSequenceKeypoint.new(0.25, 0.6, 0),
        NumberSequenceKeypoint.new(0.75, 0.6, 0),
        u13
    });
    ParticleEmitter3.Enabled = false;
    ParticleEmitter3.Rate = 0;
    ParticleEmitter3.Speed = NumberRange.new(0);
    ParticleEmitter3.Name = "RainSplash";
    ParticleEmitter3.Parent = Attachment;
    Attachment.Archivable = false;
    table.insert(u29, Attachment);
    local Attachment2 = Instance.new("Attachment");
    Attachment2.Name = "__RainOccludedAttachment";
    local v30 = Part.RainStraight:Clone();
    v30.Speed = NumberRange.new(70, 100);
    v30.SpreadAngle = v10;
    v30.LockedToPart = false;
    v30.Enabled = false;
    v30.Parent = Attachment2;
    local v31 = Part.RainTopDown:Clone();
    v31.Speed = NumberRange.new(70, 100);
    v31.SpreadAngle = v10;
    v31.LockedToPart = false;
    v31.Enabled = false;
    v31.Parent = Attachment2;
    Attachment2.Archivable = false;
    table.insert(u28, Attachment2);
end;

local u32 = { Part };
local u45 = {
    [u11.None] = function(p33, p34) -- Line: 394
        -- upvalues: Part (ref), Players (copy), u32 (copy)
        local v35;

        if p34 then
            v35 = {};
            v35[1], v35[2] = Part, Players.LocalPlayer and Players.LocalPlayer.Character;

            if not v35 then
                v35 = u32;
            end;
        else
            v35 = u32;
        end;

        return workspace:FindPartOnRayWithIgnoreList(p33, v35);
    end,

    [u11.Blacklist] = function(p36) -- Line: 397
        -- upvalues: u20 (ref)
        return workspace:FindPartOnRayWithIgnoreList(p36, u20);
    end,

    [u11.Whitelist] = function(p37) -- Line: 400
        -- upvalues: u20 (ref)
        return workspace:FindPartOnRayWithWhitelist(p37, u20);
    end,

    [u11.Function] = function(p38) -- Line: 403
        -- upvalues: u32 (copy), u25 (ref)
        local v39 = p38.Origin + p38.Direction;

        while p38.Direction.magnitude > 0.001 do
            local v40, v41, v42, v43 = workspace:FindPartOnRayWithIgnoreList(p38, u32);

            if not v40 or u25(v40) then
                return v40, v41, v42, v43;
            end;

            local v44 = v41 + p38.Direction.Unit * 0.001;
            p38 = Ray.new(v44, v39 - v44);
        end;
    end
};
local u46 = u45[None];

local function connectLoop() -- Line: 418
    -- upvalues: u21 (ref), RunService (copy), u46 (ref), u18 (ref), u19 (ref), u15 (ref), u24 (ref), TweenService (copy), Sound (copy), Part (ref), new (copy), u12 (copy), u16 (ref), u13 (copy), u22 (ref), u28 (ref), u14 (copy), u23 (ref), u29 (ref), u17 (ref)
    local u47 = Random.new();
    local u48 = true;
    local u49 = 6;
    table.insert(u21, RunService.RenderStepped:connect(function() -- Line: 426
        -- upvalues: u46 (ref), u18 (ref), u19 (ref), u15 (ref), u24 (ref), TweenService (ref), Sound (ref), u49 (ref), Part (ref), new (ref), u48 (ref)
        local v50, _ = u46(Ray.new(workspace.CurrentCamera.CFrame.p, -u18 * 1000), true);

        if u19 and workspace.CurrentCamera.CFrame.p.y > u19 or v50 then
            Part.RainStraight.Enabled = false;
            Part.RainTopDown.Enabled = false;
            u48 = true;

            return;
        end;

        if u15 < 1 and not u24 then
            u15 = 1;
            TweenService:Create(Sound, TweenInfo.new(0.5), {
                Volume = 1
            }):Play();
        end;

        u49 = 6;
        local v51 = workspace.CurrentCamera.CFrame.lookVector:Dot(u18);
        local v52 = math.abs(v51);
        local p = workspace.CurrentCamera.CFrame.p;
        local v53 = workspace.CurrentCamera.CFrame.lookVector:Cross(-u18);
        local v54 = v53.magnitude > 0.001 and v53.unit or -u18;
        local unit = u18:Cross(v54).unit;
        Part.Size = new(40, 40, (1 - v52) * 60 + 40);
        Part.CFrame = CFrame.new(p.x, p.y, p.z, v54.x, -u18.x, unit.x, v54.y, -u18.y, unit.y, v54.z, -u18.z, unit.z) + (1 - v52) * workspace.CurrentCamera.CFrame.lookVector * Part.Size.Z / 3 - v52 * u18 * 20;
        Part.RainStraight.Enabled = true;
        Part.RainTopDown.Enabled = true;
        u48 = false;
    end));
    local v55 = RunService:IsRunning() and RunService.Stepped or RunService.RenderStepped;
    table.insert(u21, v55:connect(function() -- Line: 485
        -- upvalues: u49 (ref), u18 (ref), u12 (ref), u16 (ref), u13 (ref), u22 (ref), u48 (ref), u28 (ref), u24 (ref), u19 (ref), u14 (ref), u46 (ref), u15 (ref), TweenService (ref), Sound (ref), Part (ref), u23 (ref), u29 (ref), u47 (copy), new (ref), u17 (ref)
        u49 = u49 + 1;

        if u49 >= 6 then
            local v56 = workspace.CurrentCamera.CFrame.lookVector:Dot(u18);
            local v57 = math.abs(v56);
            local v58 = NumberSequence.new({
                u12,
                NumberSequenceKeypoint.new(0.25, (1 - v57) * u16 + v57, 0),
                NumberSequenceKeypoint.new(0.75, (1 - v57) * u16 + v57, 0),
                u13
            });
            local v59 = NumberSequence.new({
                u12,
                NumberSequenceKeypoint.new(0.25, v57 * u22 + (1 - v57), 0),
                NumberSequenceKeypoint.new(0.75, v57 * u22 + (1 - v57), 0),
                u13
            });
            local v60 = workspace.Camera.CFrame:inverse() * (workspace.Camera.CFrame.p - u18);
            local new2 = NumberRange.new;
            local v61 = math.atan2(-v60.x, v60.y);
            local v62 = new2((math.deg(v61)));

            if u48 then
                for _, v in pairs(u28) do
                    v.RainStraight.Transparency = v58;
                    v.RainStraight.Rotation = v62;
                    v.RainTopDown.Transparency = v59;
                end;

                if not u24 then
                    local v63;

                    if u19 and workspace.CurrentCamera.CFrame.p.y > u19 then
                        v63 = 0;
                    else
                        local v64 = -u18 * 1000;
                        local v65 = 35;

                        for i = 1, #u14 do
                            if not u46(Ray.new(workspace.CurrentCamera.CFrame * u14[i], v64), true) then
                                v65 = u14[i].magnitude;
                                break;
                            end;
                        end;

                        v63 = 1 - v65 / 35;
                    end;

                    if math.abs(v63 - u15) > 0.01 then
                        u15 = v63;
                        TweenService:Create(Sound, TweenInfo.new(1), {
                            Volume = u15
                        }):Play();
                    end;
                end;
            else
                Part.RainStraight.Transparency = v58;
                Part.RainStraight.Rotation = v62;
                Part.RainTopDown.Transparency = v59;
            end;

            u49 = 0;
        end;

        local p = workspace.CurrentCamera.CFrame.p;
        local v66 = workspace.CurrentCamera.CFrame.lookVector:Cross(-u18);
        local v67 = v66.magnitude > 0.001 and v66.unit or -u18;
        local unit = u18:Cross(v67).unit;
        local v68 = CFrame.new(p.x, p.y, p.z, v67.x, -u18.x, unit.x, v67.y, -u18.y, unit.y, v67.z, -u18.z, unit.z);
        local v69 = u18 * 550;

        for i = 1, u23 do
            local v70 = u29[i];
            local v71 = u28[i];
            local v72 = u47:NextNumber(-100, 100);
            local v73 = u47:NextNumber(-100, 100);
            local v74, v75, v76 = u46(Ray.new(v68 * new(v72, 500, v73), v69));

            if v74 then
                v70.Position = v75 + v76 * 0.5;
                v70.RainSplash:Emit(1);

                if u48 then
                    local v77 = v75 - u18 * 50;

                    if u19 and (u19 < v77.Y and u18.Y < 0) then
                        v77 = v77 + u18 * (u19 - v77.Y) / u18.Y;
                    end;

                    v71.CFrame = v68 - v68.p + v77;
                    v71.RainStraight:Emit(u17);
                    v71.RainTopDown:Emit(u17);
                end;
            elseif u48 then
                local v78 = v68 * new(v72, u47:NextNumber(20, 100), v73);

                if u19 and (u19 < v78.Y and u18.Y < 0) then
                    v78 = v78 + u18 * (u19 - v78.Y) / u18.Y;
                end;

                v71.CFrame = v68 - v68.p + v78;
                v71.RainStraight:Emit(u17);
                v71.RainTopDown:Emit(u17);
            end;
        end;
    end));
end;

local function disconnectLoop() -- Line: 630
    -- upvalues: u21 (ref)
    if #u21 > 0 then
        for _, v in pairs(u21) do
            v:disconnect();
        end;

        u21 = {};
    end;
end;

local function disableSound(p79) -- Line: 640
    -- upvalues: u15 (ref), TweenService (copy), Sound (copy)
    u15 = 0;
    local u80 = TweenService:Create(Sound, p79, {
        Volume = 0
    });
    u80.Completed:connect(function(p81) -- Line: 645
        -- upvalues: Sound (ref), u80 (copy)
        if p81 == Enum.PlaybackState.Completed then
            Sound:Stop();
        end;

        u80:Destroy();
    end);
    u80:Play();
end;

local function disable() -- Line: 655
    -- upvalues: disconnectLoop (copy), Part (ref), u24 (ref), disableSound (copy)
    disconnectLoop();
    Part.RainStraight.Enabled = false;
    Part.RainTopDown.Enabled = false;
    Part.Size = Vector3.new(0.05, 0.05, 0.05);

    if not u24 then
        disableSound(TweenInfo.new(1));
    end;
end;

local function makeProperty(p82, p83, p84) -- Line: 672
    local v85 = Instance.new(p82);

    if p83 then
        v85.Value = p83;
    end;

    v85.Changed:connect(p84);
    p84(v85.Value);

    return v85;
end;

local function v88(p86) -- Line: 682
    -- upvalues: Part (ref), u29 (ref), u28 (ref)
    local v87 = ColorSequence.new(p86);
    Part.RainStraight.Color = v87;
    Part.RainTopDown.Color = v87;

    for _, v in pairs(u29) do
        v.RainSplash.Color = v87;
    end;

    for _, v in pairs(u28) do
        v.RainStraight.Color = v87;
        v.RainTopDown.Color = v87;
    end;
end;

local Color3Value = Instance.new("Color3Value");

if v1 then
    Color3Value.Value = v1;
end;

Color3Value.Changed:connect(v88);
v88(Color3Value.Value);

local function updateTransparency(p89) -- Line: 699
    -- upvalues: NumberValue (copy), u16 (ref), u22 (ref), u12 (copy), u13 (copy), u29 (ref)
    local v90 = (1 - p89) * (1 - NumberValue.Value);
    local v91 = 1 - v90;
    u16 = 0.7 * v90 + v91;
    u22 = 0.85 * v90 + v91;
    local v92 = NumberSequence.new({
        u12,
        NumberSequenceKeypoint.new(0.25, v90 * 0.6 + v91, 0),
        NumberSequenceKeypoint.new(0.75, v90 * 0.6 + v91, 0),
        u13
    });

    for _, v in pairs(u29) do
        v.RainSplash.Transparency = v92;
    end;
end;

local NumberValue2 = Instance.new("NumberValue");
NumberValue2.Value = 0;
NumberValue2.Changed:connect(updateTransparency);
updateTransparency(NumberValue2.Value);
NumberValue.Changed:connect(updateTransparency);

local function v94(p93) -- Line: 722
    -- upvalues: Part (ref)
    Part.RainStraight.Speed = NumberRange.new(p93 * 60);
    Part.RainTopDown.Speed = NumberRange.new(p93 * 60);
end;

local NumberValue3 = Instance.new("NumberValue");
NumberValue3.Value = 1;
NumberValue3.Changed:connect(v94);
local Value = NumberValue3.Value;
Part.RainStraight.Speed = NumberRange.new(Value * 60);
Part.RainTopDown.Speed = NumberRange.new(Value * 60);

local function v96(p95) -- Line: 729
    -- upvalues: Part (ref), u17 (ref), u23 (ref)
    Part.RainStraight.Rate = 600 * p95;
    Part.RainTopDown.Rate = 600 * p95;
    u17 = math.ceil(2 * p95);
    u23 = 20 * p95;
end;

local NumberValue4 = Instance.new("NumberValue");
NumberValue4.Value = 1;
NumberValue4.Changed:connect(v96);
local Value2 = NumberValue4.Value;
Part.RainStraight.Rate = 600 * Value2;
Part.RainTopDown.Rate = 600 * Value2;
u17 = math.ceil(2 * Value2);
u23 = 20 * Value2;

local function v98(p97) -- Line: 739
    -- upvalues: Part (ref), u28 (ref), u29 (ref)
    Part.RainStraight.LightEmission = p97;
    Part.RainTopDown.LightEmission = p97;

    for _, v in pairs(u28) do
        v.RainStraight.LightEmission = p97;
        v.RainTopDown.LightEmission = p97;
    end;

    for _, v in pairs(u29) do
        v.RainSplash.LightEmission = p97;
    end;
end;

local NumberValue5 = Instance.new("NumberValue");
NumberValue5.Value = 0.05;
NumberValue5.Changed:connect(v98);
v98(NumberValue5.Value);

local function v100(p99) -- Line: 754
    -- upvalues: Part (ref), u28 (ref), u29 (ref)
    Part.RainStraight.LightInfluence = p99;
    Part.RainTopDown.LightInfluence = p99;

    for _, v in pairs(u28) do
        v.RainStraight.LightInfluence = p99;
        v.RainTopDown.LightInfluence = p99;
    end;

    for _, v in pairs(u29) do
        v.RainSplash.LightInfluence = p99;
    end;
end;

local NumberValue6 = Instance.new("NumberValue");
NumberValue6.Value = 0.9;
NumberValue6.Changed:connect(v100);
v100(NumberValue6.Value);

local function v102(p101) -- Line: 769
    -- upvalues: u18 (ref)
    if p101.magnitude > 0.001 then
        u18 = p101.unit;
    end;
end;

local Vector3Value = Instance.new("Vector3Value");
Vector3Value.Value = Vector3.new(0, -1, 0);
Vector3Value.Changed:connect(v102);
local Value3 = Vector3Value.Value;

if Value3.magnitude > 0.001 then
    u18 = Value3.unit;
end;

local v112 = {
    CollisionMode = u11,

    Enable = function(p103, p104) -- Line: 782, Name: Enable
        -- upvalues: disconnectLoop (copy), Part (ref), u29 (ref), u28 (ref), RunService (copy), SoundGroup (copy), connectLoop (copy), TweenService (copy), NumberValue (copy), Sound (copy), u24 (ref)
        if p104 ~= nil and typeof(p104) ~= "TweenInfo" then
            error("bad argument #1 to \'Enable\' (TweenInfo expected, got " .. typeof(p104) .. ")", 2);
        end;

        disconnectLoop();
        Part.RainStraight.Enabled = true;
        Part.RainTopDown.Enabled = true;
        Part.Parent = workspace.CurrentCamera;

        for i = 1, 20 do
            u29[i].Parent = workspace.Terrain;
            u28[i].Parent = workspace.Terrain;
        end;

        if RunService:IsRunning() then
            SoundGroup.Parent = game:GetService("SoundService");
        end;

        connectLoop();

        if p104 then
            TweenService:Create(NumberValue, p104, {
                Value = 0
            }):Play();
        else
            NumberValue.Value = 0;
        end;

        if not Sound.Playing then
            Sound:Play();
            Sound.TimePosition = math.random() * Sound.TimeLength;
        end;

        u24 = false;
    end,

    Disable = function(p105, p106) -- Line: 820, Name: Disable
        -- upvalues: TweenService (copy), NumberValue (copy), disconnectLoop (copy), Part (ref), u24 (ref), disableSound (copy)
        if p106 ~= nil and typeof(p106) ~= "TweenInfo" then
            error("bad argument #1 to \'Disable\' (TweenInfo expected, got " .. typeof(p106) .. ")", 2);
        end;

        if p106 then
            local u107 = TweenService:Create(NumberValue, p106, {
                Value = 1
            });
            u107.Completed:connect(function(p108) -- Line: 828
                -- upvalues: disconnectLoop (ref), Part (ref), u24 (ref), disableSound (ref), u107 (copy)
                if p108 == Enum.PlaybackState.Completed then
                    disconnectLoop();
                    Part.RainStraight.Enabled = false;
                    Part.RainTopDown.Enabled = false;
                    Part.Size = Vector3.new(0.05, 0.05, 0.05);

                    if not u24 then
                        disableSound(TweenInfo.new(1));
                    end;
                end;

                u107:Destroy();
            end);
            u107:Play();
            disableSound(p106);
        else
            NumberValue.Value = 1;
            disconnectLoop();
            Part.RainStraight.Enabled = false;
            Part.RainTopDown.Enabled = false;
            Part.Size = Vector3.new(0.05, 0.05, 0.05);

            if not u24 then
                disableSound(TweenInfo.new(1));
            end;
        end;

        u24 = true;
    end,

    SetColor = function(p109, p110, p111) -- Line: 847, Name: SetColor
        -- upvalues: TweenService (copy), Color3Value (copy)
        if typeof(p110) == "Color3" then
            if p111 ~= nil and typeof(p111) ~= "TweenInfo" then
                error("bad argument #2 to \'SetColor\' (TweenInfo expected, got " .. typeof(p111) .. ")", 2);
            end;
        else
            error("bad argument #1 to \'SetColor\' (Color3 expected, got " .. typeof(p110) .. ")", 2);
        end;

        if p111 then
            TweenService:Create(Color3Value, p111, {
                Value = p110
            }):Play();

            return;
        end;

        Color3Value.Value = p110;
    end
};

local function makeRatioSetter(u113, u114) -- Line: 863
    -- upvalues: TweenService (copy)
    return function(p115, p116, p117) -- Line: 865
        -- upvalues: u113 (copy), TweenService (ref), u114 (copy)
        if typeof(p116) == "number" then
            if p117 ~= nil and typeof(p117) ~= "TweenInfo" then
                error("bad argument #2 to \'" .. u113 .. "\' (TweenInfo expected, got " .. typeof(p117) .. ")", 2);
            end;
        else
            error("bad argument #1 to \'" .. u113 .. "\' (number expected, got " .. typeof(p116) .. ")", 2);
        end;

        local v118 = math.clamp(p116, 0, 1);

        if p117 then
            TweenService:Create(u114, p117, {
                Value = v118
            }):Play();

            return;
        end;

        u114.Value = v118;
    end;
end;

local u119 = "SetTransparency";

function v112.SetTransparency(p120, p121, p122) -- Line: 865
    -- upvalues: u119 (copy), TweenService (copy), NumberValue2 (copy)
    if typeof(p121) == "number" then
        if p122 ~= nil and typeof(p122) ~= "TweenInfo" then
            error("bad argument #2 to \'" .. u119 .. "\' (TweenInfo expected, got " .. typeof(p122) .. ")", 2);
        end;
    else
        error("bad argument #1 to \'" .. u119 .. "\' (number expected, got " .. typeof(p121) .. ")", 2);
    end;

    local v123 = math.clamp(p121, 0, 1);

    if p122 then
        TweenService:Create(NumberValue2, p122, {
            Value = v123
        }):Play();

        return;
    end;

    NumberValue2.Value = v123;
end;

local u124 = "SetSpeedRatio";

function v112.SetSpeedRatio(p125, p126, p127) -- Line: 865
    -- upvalues: u124 (copy), TweenService (copy), NumberValue3 (copy)
    if typeof(p126) == "number" then
        if p127 ~= nil and typeof(p127) ~= "TweenInfo" then
            error("bad argument #2 to \'" .. u124 .. "\' (TweenInfo expected, got " .. typeof(p127) .. ")", 2);
        end;
    else
        error("bad argument #1 to \'" .. u124 .. "\' (number expected, got " .. typeof(p126) .. ")", 2);
    end;

    local v128 = math.clamp(p126, 0, 1);

    if p127 then
        TweenService:Create(NumberValue3, p127, {
            Value = v128
        }):Play();

        return;
    end;

    NumberValue3.Value = v128;
end;

local u129 = "SetIntensityRatio";

function v112.SetIntensityRatio(p130, p131, p132) -- Line: 865
    -- upvalues: u129 (copy), TweenService (copy), NumberValue4 (copy)
    if typeof(p131) == "number" then
        if p132 ~= nil and typeof(p132) ~= "TweenInfo" then
            error("bad argument #2 to \'" .. u129 .. "\' (TweenInfo expected, got " .. typeof(p132) .. ")", 2);
        end;
    else
        error("bad argument #1 to \'" .. u129 .. "\' (number expected, got " .. typeof(p131) .. ")", 2);
    end;

    local v133 = math.clamp(p131, 0, 1);

    if p132 then
        TweenService:Create(NumberValue4, p132, {
            Value = v133
        }):Play();

        return;
    end;

    NumberValue4.Value = v133;
end;

local u134 = "SetLightEmission";

function v112.SetLightEmission(p135, p136, p137) -- Line: 865
    -- upvalues: u134 (copy), TweenService (copy), NumberValue5 (copy)
    if typeof(p136) == "number" then
        if p137 ~= nil and typeof(p137) ~= "TweenInfo" then
            error("bad argument #2 to \'" .. u134 .. "\' (TweenInfo expected, got " .. typeof(p137) .. ")", 2);
        end;
    else
        error("bad argument #1 to \'" .. u134 .. "\' (number expected, got " .. typeof(p136) .. ")", 2);
    end;

    local v138 = math.clamp(p136, 0, 1);

    if p137 then
        TweenService:Create(NumberValue5, p137, {
            Value = v138
        }):Play();

        return;
    end;

    NumberValue5.Value = v138;
end;

local u139 = "SetLightInfluence";

function v112.SetLightInfluence(p140, p141, p142) -- Line: 865
    -- upvalues: u139 (copy), TweenService (copy), NumberValue6 (copy)
    if typeof(p141) == "number" then
        if p142 ~= nil and typeof(p142) ~= "TweenInfo" then
            error("bad argument #2 to \'" .. u139 .. "\' (TweenInfo expected, got " .. typeof(p142) .. ")", 2);
        end;
    else
        error("bad argument #1 to \'" .. u139 .. "\' (number expected, got " .. typeof(p141) .. ")", 2);
    end;

    local v143 = math.clamp(p141, 0, 1);

    if p142 then
        TweenService:Create(NumberValue6, p142, {
            Value = v143
        }):Play();

        return;
    end;

    NumberValue6.Value = v143;
end;

function v112.SetVolume(p144, p145, p146) -- Line: 890
    -- upvalues: TweenService (copy), SoundGroup (copy)
    if typeof(p145) == "number" then
        if p146 ~= nil and typeof(p146) ~= "TweenInfo" then
            error("bad argument #2 to \'SetVolume\' (TweenInfo expected, got " .. typeof(p146) .. ")", 2);
        end;
    else
        error("bad argument #1 to \'SetVolume\' (number expected, got " .. typeof(p145) .. ")", 2);
    end;

    if p146 then
        TweenService:Create(SoundGroup, p146, {
            Volume = p145
        }):Play();

        return;
    end;

    SoundGroup.Volume = p145;
end;

function v112.SetDirection(p147, p148, p149) -- Line: 906
    -- upvalues: TweenService (copy), Vector3Value (copy)
    if typeof(p148) == "Vector3" then
        if p149 ~= nil and typeof(p149) ~= "TweenInfo" then
            error("bad argument #2 to \'SetDirection\' (TweenInfo expected, got " .. typeof(p149) .. ")", 2);
        end;
    else
        error("bad argument #1 to \'SetDirection\' (Vector3 expected, got " .. typeof(p148) .. ")", 2);
    end;

    if p148.unit.magnitude <= 0 then
        warn("Attempt to set rain direction to a zero-length vector, falling back on default direction = (" .. tostring(Vector3.new(0, -1, 0)) .. ")");
        p148 = Vector3.new(0, -1, 0);
    end;

    if p149 then
        TweenService:Create(Vector3Value, p149, {
            Value = p148
        }):Play();

        return;
    end;

    Vector3Value.Value = p148;
end;

function v112.SetCeiling(p150, p151) -- Line: 927
    -- upvalues: u19 (ref)
    if p151 ~= nil and typeof(p151) ~= "number" then
        error("bad argument #1 to \'SetCeiling\' (number expected, got " .. typeof(p151) .. ")", 2);
    end;

    u19 = p151;
end;

function v112.SetStraightTexture(p152, p153) -- Line: 937
    -- upvalues: Part (ref), u28 (ref)
    if typeof(p153) ~= "string" then
        error("bad argument #1 to \'SetStraightTexture\' (string expected, got " .. typeof(p153) .. ")", 2);
    end;

    Part.RainStraight.Texture = p153;

    for _, v in pairs(u28) do
        v.RainStraight.Texture = p153;
    end;
end;

function v112.SetTopDownTexture(p154, p155) -- Line: 951
    -- upvalues: Part (ref), u28 (ref)
    if typeof(p155) ~= "string" then
        error("bad argument #1 to \'SetStraightTexture\' (string expected, got " .. typeof(p155) .. ")", 2);
    end;

    Part.RainTopDown.Texture = p155;

    for _, v in pairs(u28) do
        v.RainTopDown.Texture = p155;
    end;
end;

function v112.SetSplashTexture(p156, p157) -- Line: 965
    -- upvalues: u29 (ref)
    if typeof(p157) ~= "string" then
        error("bad argument #1 to \'SetStraightTexture\' (string expected, got " .. typeof(p157) .. ")", 2);
    end;

    for _, v in pairs(u29) do
        v.RainSplash.Texture = p157;
    end;
end;

function v112.SetSoundId(p158, p159) -- Line: 977
    -- upvalues: Sound (copy)
    if typeof(p159) ~= "string" then
        error("bad argument #1 to \'SetSoundId\' (string expected, got " .. typeof(p159) .. ")", 2);
    end;

    Sound.SoundId = p159;
end;

function v112.SetCollisionMode(p160, p161, p162) -- Line: 987
    -- upvalues: u11 (copy), u20 (ref), u25 (ref), Part (ref), None (ref), u46 (ref), u45 (copy)
    if p161 == u11.None then
        u20 = nil;
        u25 = nil;
    elseif p161 == u11.Blacklist then
        if typeof(p162) == "Instance" then
            u20 = { p162, Part };
        elseif typeof(p162) == "table" then
            for i = 1, #p162 do
                if typeof(p162[i]) ~= "Instance" then
                    error("bad argument #2 to \'SetCollisionMode\' (blacklist contained a " .. typeof(p162[i]) .. " on index " .. tostring(i) .. " which is not an Instance)", 2);
                end;
            end;

            u20 = { Part };

            for i = 1, #p162 do
                table.insert(u20, p162[i]);
            end;
        else
            error("bad argument #2 to \'SetCollisionMode (Instance or array of Instance expected, got " .. typeof(p162) .. ")\'", 2);
        end;

        u25 = nil;
    elseif p161 == u11.Whitelist then
        if typeof(p162) == "Instance" then
            u20 = { p162 };
        elseif typeof(p162) == "table" then
            for i = 1, #p162 do
                if typeof(p162[i]) ~= "Instance" then
                    error("bad argument #2 to \'SetCollisionMode\' (whitelist contained a " .. typeof(p162[i]) .. " on index " .. tostring(i) .. " which is not an Instance)", 2);
                end;
            end;

            u20 = {};

            for i = 1, #p162 do
                table.insert(u20, p162[i]);
            end;
        else
            error("bad argument #2 to \'SetCollisionMode (Instance or array of Instance expected, got " .. typeof(p162) .. ")\'", 2);
        end;

        u25 = nil;
    elseif p161 == u11.Function then
        if typeof(p162) ~= "function" then
            error("bad argument #2 to \'SetCollisionMode\' (function expected, got " .. typeof(p162) .. ")", 2);
        end;

        u20 = nil;
        u25 = p162;
    else
        error("bad argument #1 to \'SetCollisionMode (Rain.CollisionMode expected, got " .. typeof(p162) .. ")\'", 2);
    end;

    None = p161;
    u46 = u45[p161];
end;

return v112;