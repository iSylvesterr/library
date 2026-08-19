-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 4
};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local Assets = ReplicatedStorage:WaitForChild("Assets");
local Robin = Assets:WaitForChild("Pets"):WaitForChild("Robin");
local PopVFX = Assets:WaitForChild("PopVFX");
local Birds = workspace:WaitForChild("Birds");
local Folder = Instance.new("Folder");
Folder.Name = "BirdVisuals";
Folder.Parent = workspace;
local u2 = {};
local u3 = {};
Networking.Bird.Positions.OnClientEvent:Connect(function(p4) -- Line: 36
    -- upvalues: u3 (copy)
    if typeof(p4) ~= "table" then
        return;
    end;

    for _, v in p4 do
        local v5 = v[1];
        local v6 = v[2];

        if typeof(v5) == "Instance" and (v5:IsA("BasePart") and typeof(v6) == "Vector3") then
            u3[v5] = v6;
        end;
    end;
end);
Networking.Bird.FruitEaten.OnClientEvent:Connect(function(p7) -- Line: 47
    -- upvalues: PopVFX (copy), Folder (copy)
    if typeof(p7) ~= "Vector3" then
        return;
    end;

    local v8 = PopVFX:Clone();

    if v8:IsA("BasePart") then
        v8.CFrame = CFrame.new(p7);
        v8.Parent = Folder;
        game.Debris:AddItem(v8, 3);

        return;
    end;

    if v8:IsA("Model") then
        v8:PivotTo(CFrame.new(p7));
        v8.Parent = Folder;
        game.Debris:AddItem(v8, 3);

        for _, descendant in v8:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant:Emit(descendant:GetAttribute("EmitCount") or 50);
            end;
        end;

        return;
    end;

    local Model = Instance.new("Model");
    v8.Parent = Model;
    Model.Parent = Folder;
    Model:PivotTo(CFrame.new(p7));
    game.Debris:AddItem(Model, 3);
end);

local function setupVisualBird(p9) -- Line: 72
    -- upvalues: u2 (copy), Robin (copy), u3 (copy), Folder (copy), SoundService (copy)
    if u2[p9] then
        return;
    end;

    local v10 = Robin:Clone();
    v10.Name = "BirdVisual_" .. p9.Name;
    local PrimaryPart = v10.PrimaryPart;

    if PrimaryPart then
        PrimaryPart.Anchored = true;
    end;

    for _, descendant in v10:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;

            if descendant ~= PrimaryPart then
                descendant.Anchored = false;
            end;
        end;
    end;

    local v11 = u3[p9] or p9.Position;
    local v12 = CFrame.new(v11);

    if PrimaryPart then
        v10:PivotTo(v12);
    end;

    v10.Parent = Folder;
    local v13;

    if PrimaryPart then
        v13 = Instance.new("Sound");
        v13.SoundId = "rbxassetid://100707184833885";
        v13.Volume = 0.2;
        v13.PlaybackSpeed = 1;
        v13.RollOffMaxDistance = 400;
        v13.RollOffMode = Enum.RollOffMode.InverseTapered;
        v13.Looped = true;
        v13.SoundGroup = SoundService:FindFirstChild("SFXGroup");
        v13.Parent = PrimaryPart;
        v13:Play();
    else
        v13 = nil;
    end;

    u2[p9] = {
        Part = p9,
        Model = v10,
        CurrentCF = v12,
        LastTargetPos = v11,
        Sound = v13
    };
end;

local function cleanupVisualBird(p14) -- Line: 124
    -- upvalues: u2 (copy), u3 (copy)
    local v15 = u2[p14];

    if not v15 then
        return;
    end;

    if v15.Sound then
        v15.Sound:Stop();
    end;

    if v15.Model then
        v15.Model:Destroy();
    end;

    u3[p14] = nil;
    u2[p14] = nil;
end;

function v1.Init(p16) -- Line: 133
end;

function v1.Start(p17) -- Line: 136
    -- upvalues: Birds (copy), setupVisualBird (copy), u2 (copy), u3 (copy), RunService (copy)
    for _, child in Birds:GetChildren() do
        if child:IsA("BasePart") then
            setupVisualBird(child);
        end;
    end;

    Birds.ChildAdded:Connect(function(p18) -- Line: 143
        -- upvalues: setupVisualBird (ref)
        if p18:IsA("BasePart") then
            setupVisualBird(p18);
        end;
    end);
    Birds.ChildRemoved:Connect(function(p19) -- Line: 149
        -- upvalues: u2 (ref), u3 (ref)
        if p19:IsA("BasePart") then
            local v20 = u2[p19];

            if not v20 then
                return;
            end;

            if v20.Sound then
                v20.Sound:Stop();
            end;

            if v20.Model then
                v20.Model:Destroy();
            end;

            u3[p19] = nil;
            u2[p19] = nil;
        end;
    end);
    RunService.RenderStepped:Connect(function(p21) -- Line: 155
        -- upvalues: u2 (ref), u3 (ref)
        debug.profilebegin("Controllers/BirdVisualController/RenderStepped");
        local v22 = math.min(1, 14 * p21);

        for i, v in u2 do
            if i and i.Parent then
                local Model = v.Model;

                if Model and Model.PrimaryPart then
                    local v23 = u3[i] or i.Position;
                    local v24 = v.CurrentCF.Position:Lerp(v23, v22);
                    local v25 = v23.X - v.LastTargetPos.X;
                    local v26 = v23.Z - v.LastTargetPos.Z;
                    local v27;

                    if v25 * v25 + v26 * v26 > 0.0001 then
                        local v28 = v24 + Vector3.new(v25, (v23.Y - v.LastTargetPos.Y) * 0.5, v26);
                        v27 = CFrame.lookAt(v24, v28);
                    else
                        local _, v29, _ = v.CurrentCF:ToEulerAnglesYXZ();
                        v27 = CFrame.new(v24) * CFrame.Angles(0, v29, 0);
                    end;

                    v.CurrentCF = v27;
                    Model.PrimaryPart.CFrame = v27;
                    v.LastTargetPos = v23;
                end;
            else
                local v30 = u2[i];

                if v30 then
                    if v30.Sound then
                        v30.Sound:Stop();
                    end;

                    if v30.Model then
                        v30.Model:Destroy();
                    end;

                    u3[i] = nil;
                    u2[i] = nil;
                end;
            end;
        end;

        debug.profileend();
    end);
end;

return v1;