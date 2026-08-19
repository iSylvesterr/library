-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local TeleporterData = require(ReplicatedStorage.SharedModules.TeleporterData);
local LocalPlayer = Players.LocalPlayer;
local Temporary = workspace:WaitForChild("Temporary");
local u1 = {};
local u2 = nil;
local u3 = nil;
local u4 = false;
local u5 = nil;
local v6 = {
    StartOrder = 1
};
local u7 = 10;
local u8 = { 0.9, 0.8, 0.7, 0.6, 0.5 };
local u9 = nil;
local u10 = 0;

for _, v in TeleporterData.Data do
    u1[v.Name] = v.TeleportDistance;
end;

local function getCharacter() -- Line: 58
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer.Character;
end;

local function getHumanoidRootPart() -- Line: 62
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("Head");
    end;

    return Character;
end;

local function getForwardCFrame(p11) -- Line: 67
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("Head");
    end;

    if not Character then
        return nil;
    end;

    local LookVector = Character.CFrame.LookVector;
    local v12 = Vector3.new(LookVector.X, 0, LookVector.Z);

    if v12.Magnitude < 0.01 then
        return nil;
    end;

    return Character.CFrame + v12.Unit * p11;
end;

local function applyTransparencyToClone(p13, p14) -- Line: 83
    for _, descendant in p13:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Transparency = math.max(descendant.Transparency, p14);
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Anchored = true;
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            descendant.Transparency = math.max(descendant.Transparency, p14);
        elseif descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or descendant:IsA("Beam")) then
            descendant.Enabled = false;
        elseif descendant:IsA("Fire") or (descendant:IsA("Smoke") or descendant:IsA("Sparkles")) then
            descendant.Enabled = false;
        elseif descendant:IsA("Light") then
            descendant.Enabled = false;
        end;
    end;

    for _, child in p13:GetChildren() do
        if child:IsA("Accessory") then
            local Handle = child:FindFirstChild("Handle");

            if Handle and Handle:IsA("BasePart") then
                Handle.Transparency = math.max(Handle.Transparency, p14);
                Handle.Anchored = true;
                Handle.CanCollide = false;
                Handle.CanQuery = false;
                Handle.CanTouch = false;
            end;
        end;
    end;
end;

local function fadeOutClone(u15, p16) -- Line: 116
    -- upvalues: TweenService (copy), Debris (copy)
    local v17 = {};

    for _, descendant in u15:GetDescendants() do
        if descendant:IsA("BasePart") then
            local v18 = TweenService:Create(descendant, TweenInfo.new(p16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Transparency = 1
            });
            v18:Play();
            table.insert(v17, v18);
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            TweenService:Create(descendant, TweenInfo.new(p16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Transparency = 1
            }):Play();
        end;
    end;

    if #v17 > 0 then
        v17[1].Completed:Once(function() -- Line: 135
            -- upvalues: u15 (copy)
            u15:Destroy();
        end);
    else
        Debris:AddItem(u15, p16);
    end;

    Debris:AddItem(u15, p16 + 1);
end;

local function clearPreview() -- Line: 149
    -- upvalues: u3 (ref), u9 (ref), u4 (ref)
    if u3 then
        u3:Destroy();
        u3 = nil;
    end;

    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;

    u4 = false;
end;

local function createPreview() -- Line: 161
    -- upvalues: u5 (ref), u3 (ref), u9 (ref), u4 (ref), LocalPlayer (copy), applyTransparencyToClone (copy), Temporary (copy)
    if u5 == nil then
        return;
    end;

    if u3 then
        u3:Destroy();
        u3 = nil;
    end;

    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;

    u4 = false;
    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    if not Character:FindFirstChildOfClass("Humanoid") then
        return;
    end;

    Character.Archivable = true;
    local v19 = u5:Clone();
    v19.Name = "TeleportPreview";
    Character.Archivable = false;

    if Character.PrimaryPart then
        local v20 = v19:FindFirstChild(Character.PrimaryPart.Name);

        if v20 and v20:IsA("BasePart") then
            v19.PrimaryPart = v20;
        end;
    end;

    applyTransparencyToClone(v19, 0.5);
    v19.Parent = Temporary;
    u3 = v19;
end;

local function updatePreview() -- Line: 190
    -- upvalues: u3 (ref), u7 (ref), LocalPlayer (copy), u4 (ref), Temporary (copy)
    if not u3 then
        return;
    end;

    if not u3.PrimaryPart then
        return;
    end;

    local v21 = u7;
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("Head");
    end;

    local v22;

    if Character then
        local LookVector = Character.CFrame.LookVector;
        local v23 = Vector3.new(LookVector.X, 0, LookVector.Z);

        if v23.Magnitude < 0.01 then
            v22 = nil;
        else
            v22 = Character.CFrame + v23.Unit * v21;
        end;
    else
        v22 = nil;
    end;

    if not v22 then
        if u4 then
            u3.Parent = nil;
            u4 = false;
        end;

        return;
    end;

    if not u4 then
        u3.Parent = Temporary;
        u4 = true;
    end;

    u3:SetPrimaryPartCFrame(v22);
end;

local function spawnTeleportTrail(p24, p25) -- Line: 215
    -- upvalues: LocalPlayer (copy), applyTransparencyToClone (copy), u8 (copy), Temporary (copy), fadeOutClone (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    Character.Archivable = true;
    local v26 = Character:Clone();
    Character.Archivable = false;

    for _, descendant in v26:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CollisionGroup = "NoPlayers";
        end;
    end;

    for i = 1, 5 do
        local v27 = p24:Lerp(p25, i / 5);
        local u28 = v26:Clone();
        u28.Name = "TeleportTrail_" .. tostring(i);

        if Character.PrimaryPart then
            local v29 = u28:FindFirstChild(Character.PrimaryPart.Name);

            if v29 and v29:IsA("BasePart") then
                u28.PrimaryPart = v29;
            end;
        end;

        applyTransparencyToClone(u28, u8[i]);
        u28.Parent = Temporary;

        if u28.PrimaryPart then
            u28:SetPrimaryPartCFrame(v27);
        end;

        task.delay((i - 1) * 0.03, function() -- Line: 256
            -- upvalues: u28 (copy), fadeOutClone (ref)
            if u28 and u28.Parent then
                fadeOutClone(u28, 0.6);
            end;
        end);
    end;

    v26:Destroy();
end;

local function doTeleport() -- Line: 271
    -- upvalues: LocalPlayer (copy), u7 (ref), Networking (copy), spawnTeleportTrail (copy)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("Head");
    end;

    if not Character then
        return;
    end;

    local Character2 = LocalPlayer.Character;

    if not Character2 then
        return;
    end;

    local v30 = Character2:FindFirstChildOfClass("Humanoid");

    if not v30 or v30.Health <= 0 then
        return;
    end;

    local v31 = u7;
    local Character3 = LocalPlayer.Character;

    if Character3 then
        Character3 = Character3:FindFirstChild("Head");
    end;

    local v32;

    if Character3 then
        local LookVector = Character3.CFrame.LookVector;
        local v33 = Vector3.new(LookVector.X, 0, LookVector.Z);

        if v33.Magnitude < 0.01 then
            v32 = nil;
        else
            v32 = Character3.CFrame + v33.Unit * v31;
        end;
    else
        v32 = nil;
    end;

    if not v32 then
        return;
    end;

    local CFrame = Character.CFrame;
    Character.CFrame = v32;
    Networking.Place.UseTeleporter:Fire(v32.Position);
    spawnTeleportTrail(CFrame, v32);
end;

local function onToolEquipped(p34) -- Line: 299
    -- upvalues: u2 (ref), u7 (ref), u1 (copy), createPreview (copy), u9 (ref), RunService (copy), u3 (ref), LocalPlayer (copy), u4 (ref), Temporary (copy)
    if not p34:GetAttribute("Teleporter") then
        return;
    end;

    u2 = p34;
    u7 = u1[p34:GetAttribute("Teleporter")] or 10;
    createPreview();
    u9 = RunService.RenderStepped:Connect(function() -- Line: 308
        -- upvalues: u3 (ref), u7 (ref), LocalPlayer (ref), u4 (ref), Temporary (ref)
        debug.profilebegin("Controllers/TeleporterController/PreviewUpdate");

        if u3 and u3.PrimaryPart then
            local v35 = u7;
            local Character = LocalPlayer.Character;

            if Character then
                Character = Character:FindFirstChild("Head");
            end;

            local v36;

            if Character then
                local LookVector = Character.CFrame.LookVector;
                local v37 = Vector3.new(LookVector.X, 0, LookVector.Z);

                if v37.Magnitude < 0.01 then
                    v36 = nil;
                else
                    v36 = Character.CFrame + v37.Unit * v35;
                end;
            else
                v36 = nil;
            end;

            if v36 then
                if not u4 then
                    u3.Parent = Temporary;
                    u4 = true;
                end;

                u3:SetPrimaryPartCFrame(v36);
            elseif u4 then
                u3.Parent = nil;
                u4 = false;
            end;
        end;

        debug.profileend();
    end);
end;

local function onToolUnequipped(p38) -- Line: 315
    -- upvalues: u2 (ref), u3 (ref), u9 (ref), u4 (ref)
    if u2 ~= p38 then
        return;
    end;

    u2 = nil;

    if u3 then
        u3:Destroy();
        u3 = nil;
    end;

    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;

    u4 = false;
end;

local function tryTeleport() -- Line: 325
    -- upvalues: u2 (ref), u10 (ref), doTeleport (copy), createPreview (copy), u9 (ref), RunService (copy), u3 (ref), u7 (ref), LocalPlayer (copy), u4 (ref), Temporary (copy)
    if not u2 then
        return;
    end;

    local v39 = os.clock();

    if v39 - u10 < 1 then
        return;
    end;

    u10 = v39;
    doTeleport();
    task.defer(function() -- Line: 335
        -- upvalues: u2 (ref), createPreview (ref), u9 (ref), RunService (ref), u3 (ref), u7 (ref), LocalPlayer (ref), u4 (ref), Temporary (ref)
        if u2 then
            createPreview();

            if not u9 then
                u9 = RunService.RenderStepped:Connect(function() -- Line: 339
                    -- upvalues: u3 (ref), u7 (ref), LocalPlayer (ref), u4 (ref), Temporary (ref)
                    debug.profilebegin("Controllers/TeleporterController/PreviewUpdate");

                    if u3 and u3.PrimaryPart then
                        local v40 = u7;
                        local Character = LocalPlayer.Character;

                        if Character then
                            Character = Character:FindFirstChild("Head");
                        end;

                        local v41;

                        if Character then
                            local LookVector = Character.CFrame.LookVector;
                            local v42 = Vector3.new(LookVector.X, 0, LookVector.Z);

                            if v42.Magnitude < 0.01 then
                                v41 = nil;
                            else
                                v41 = Character.CFrame + v42.Unit * v40;
                            end;
                        else
                            v41 = nil;
                        end;

                        if v41 then
                            if not u4 then
                                u3.Parent = Temporary;
                                u4 = true;
                            end;

                            u3:SetPrimaryPartCFrame(v41);
                        elseif u4 then
                            u3.Parent = nil;
                            u4 = false;
                        end;
                    end;

                    debug.profileend();
                end);
            end;
        end;
    end);
end;

local function onInput(p43, p44) -- Line: 349
    -- upvalues: tryTeleport (copy)
    if p44 then
        return;
    end;

    if p43.UserInputType ~= Enum.UserInputType.MouseButton1 and p43.KeyCode ~= Enum.KeyCode.ButtonR2 then
        return;
    end;

    tryTeleport();
end;

local function setupCharacter(p45) -- Line: 363
    -- upvalues: onToolEquipped (copy), u2 (ref), u3 (ref), u9 (ref), u4 (ref)
    p45.ChildAdded:Connect(function(p46) -- Line: 364
        -- upvalues: onToolEquipped (ref)
        if p46:IsA("Tool") then
            onToolEquipped(p46);
        end;
    end);
    p45.ChildRemoved:Connect(function(p47) -- Line: 370
        -- upvalues: u2 (ref), u3 (ref), u9 (ref), u4 (ref)
        if p47:IsA("Tool") then
            if u2 ~= p47 then
                return;
            end;

            u2 = nil;

            if u3 then
                u3:Destroy();
                u3 = nil;
            end;

            if u9 then
                u9:Disconnect();
                u9 = nil;
            end;

            u4 = false;
        end;
    end);

    for _, child in p45:GetChildren() do
        if child:IsA("Tool") then
            onToolEquipped(child);
        end;
    end;
end;

function SetupPreview()
    -- upvalues: u5 (ref)
    local Character = game.Players.LocalPlayer.Character;

    if Character == nil then
        return;
    end;

    Character.Archivable = true;
    u5 = Character:Clone();
    u5.Parent = game.ReplicatedStorage.Assets;
    u5.Name = "ExtraPreview";
    Character.Archivable = false;
end;

function v6.Init(p48) -- Line: 397
end;

function v6.Start(p49) -- Line: 400
    -- upvalues: UserInputService (copy), tryTeleport (copy), LocalPlayer (copy), setupCharacter (copy), u3 (ref), u9 (ref), u4 (ref), u2 (ref)
    UserInputService.InputBegan:Connect(function(p50, p51) -- Line: 401
        -- upvalues: tryTeleport (ref)
        if p51 then
            return;
        end;

        if p50.UserInputType ~= Enum.UserInputType.MouseButton1 and p50.KeyCode ~= Enum.KeyCode.ButtonR2 then
            return;
        end;

        tryTeleport();
    end);
    local Character = LocalPlayer.Character;

    if Character then
        setupCharacter(Character);
    end;

    if LocalPlayer:HasAppearanceLoaded() == true then
        SetupPreview();
    end;

    LocalPlayer.CharacterAdded:Connect(function(p52) -- Line: 414
        -- upvalues: u3 (ref), u9 (ref), u4 (ref), u2 (ref), setupCharacter (ref)
        if u3 then
            u3:Destroy();
            u3 = nil;
        end;

        if u9 then
            u9:Disconnect();
            u9 = nil;
        end;

        u4 = false;
        u2 = nil;
        setupCharacter(p52);
    end);
    LocalPlayer.CharacterAppearanceLoaded:Connect(function(p53) -- Line: 420
        SetupPreview();
    end);
end;

return v6;