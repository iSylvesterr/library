-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local FreezeRay = game.SoundService.SFX.FreezeRay;
local LocalPlayer = Players.LocalPlayer;

function v1.Init(p2) -- Line: 11
end;

function v1.Start(u3) -- Line: 14
    -- upvalues: LocalPlayer (copy), Networking (copy)
    local Character = LocalPlayer.Character;

    if Character then
        u3:SetupCharacter(Character);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p4) -- Line: 20
        -- upvalues: u3 (copy)
        u3:SetupCharacter(p4);
    end);
    Networking.FreezeRay.FreezeFx.OnClientEvent:Connect(function(p5, p6) -- Line: 24
        -- upvalues: u3 (copy)
        u3:PlayFreezeFx(p5, p6);
    end);
end;

function v1.SetupCharacter(u7, p8) -- Line: 29
    p8.ChildAdded:Connect(function(u9) -- Line: 30, Name: tryConnect
        -- upvalues: u7 (copy)
        if u9:IsA("Tool") and u9:GetAttribute("FreezeRay") then
            u9.Activated:Connect(function() -- Line: 32
                -- upvalues: u7 (ref), u9 (copy)
                u7:OnToolActivated(u9);
            end);
        end;
    end);

    for _, child in p8:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("FreezeRay") then
            child.Activated:Connect(function() -- Line: 32
                -- upvalues: u7 (copy), child (copy)
                u7:OnToolActivated(child);
            end);
        end;
    end;
end;

local Animation = Instance.new("Animation");
Animation.AnimationId = "rbxassetid://117986819831165";

function v1.OnToolActivated(p10, p11) -- Line: 50
    -- upvalues: LocalPlayer (copy), FreezeRay (copy), Networking (copy), Animation (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    if p11.Parent ~= Character then
        return;
    end;

    local v12 = p11:GetAttribute("CooldownEnd");

    if v12 and os.clock() < v12 then
        return;
    end;

    local v13 = LocalPlayer:GetMouse();

    if not v13 then
        return;
    end;

    local v14 = p10:GetFilteredMouseTarget(v13, Character);

    if not v14 then
        return;
    end;

    FreezeRay.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
    FreezeRay.Playing = true;
    FreezeRay.TimePosition = 0;
    Networking.FreezeRay.Fire:Fire(v14, p11);
    local v15 = Character.Humanoid.Animator:LoadAnimation(Animation);
    v15:Play();
    game.Debris:AddItem(v15, 1);
    local v16 = p11:GetAttribute("Cooldown") or 10;
    p11:SetAttribute("CooldownEnd", os.clock() + v16);
end;

function v1.GetFilteredMouseTarget(p17, p18, p19) -- Line: 83
    local v20 = workspace.CurrentCamera:ScreenPointToRay(p18.X, p18.Y);
    local v21 = RaycastParams.new();
    v21.FilterType = Enum.RaycastFilterType.Exclude;
    v21.FilterDescendantsInstances = { p19 };
    local Origin = v20.Origin;
    local v22 = v20.Direction * 1000;

    for _ = 1, 10 do
        local v23 = workspace:Raycast(Origin, v22, v21);

        if not v23 then
            return Origin + v22;
        end;

        if v23.Instance.Transparency < 1 then
            return v23.Position;
        end;

        local FilterDescendantsInstances = v21.FilterDescendantsInstances;
        table.insert(FilterDescendantsInstances, v23.Instance);
        v21.FilterDescendantsInstances = FilterDescendantsInstances;
        local v24 = v22.Magnitude - (v23.Position - Origin).Magnitude;
        Origin = v23.Position + v20.Direction * 0.01;
        v22 = v20.Direction * v24;
    end;

    return Origin + v22;
end;

function v1.PlayFreezeFx(p25, p26, p27) -- Line: 117
end;

local function newIceBlock(u28) -- Line: 122
    local v29 = script.Highlight:Clone();
    v29.Parent = u28;
    v29.Enabled = true;
    v29.Adornee = u28;
    game.TweenService:Create(v29, TweenInfo.new(0.1), {
        FillTransparency = 1,
        OutlineTransparency = 1
    }):Play();
    game.Debris:AddItem(v29, 0.1);
    task.delay(0.1, function() -- Line: 133
        -- upvalues: u28 (copy)
        game.TweenService:Create(u28, TweenInfo.new(0.1), {
            Transparency = 0.4
        }):Play();
    end);

    for _, child in u28:GetChildren() do
        if child:IsA("ParticleEmitter") then
            child:Emit(child:GetAttribute("EmitCount") or 0);
        elseif child:IsA("PointLight") then
            game.TweenService:Create(child, TweenInfo.new(0.1), {
                Brightness = 6
            }):Play();
            task.delay(0.3, function() -- Line: 143
                -- upvalues: child (copy)
                game.TweenService:Create(child, TweenInfo.new(0.1), {
                    Brightness = 1
                }):Play();
            end);
        end;
    end;
end;

for _, v in game.CollectionService:GetTagged("Ice_Block") do
    newIceBlock(v);
end;

game:GetService("CollectionService"):GetInstanceAddedSignal("Ice_Block"):Connect(newIceBlock);

return v1;