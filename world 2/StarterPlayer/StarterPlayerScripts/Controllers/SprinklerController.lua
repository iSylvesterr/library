-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 1
};
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local CollectionService = game:GetService("CollectionService");
local TweenService = game:GetService("TweenService");
game:GetService("Debris");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local Sprinklers = ReplicatedStorage.Assets.Sprinklers;
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local SprinklerData = require(ReplicatedStorage.SharedModules.SprinklerData);
local CutsceneGate = require(ReplicatedStorage.ClientModules.CutsceneGate);
local RadiusPreviewHeight = require(ReplicatedStorage.ClientModules.RadiusPreviewHeight);
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = workspace.CurrentCamera;
local Gardens = workspace:WaitForChild("Gardens");
local Assets = ReplicatedStorage.Assets;
local _ = Assets.Dirt;
local _ = Assets.Seeds;
local Temporary = workspace.Temporary;
local u2 = 0;
TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
TweenInfo.new(0.12, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out);
TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
local u3 = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
local _ = {
    Color3.fromRGB(101, 67, 33),
    Color3.fromRGB(92, 60, 28),
    Color3.fromRGB(110, 75, 40),
    Color3.fromRGB(85, 55, 25)
};
local u4 = Color3.fromRGB(100, 255, 100);
local u5 = Color3.fromRGB(255, 100, 100);
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = {};

function v1.Init(p12) -- Line: 69
    -- upvalues: SprinklerData (copy), u11 (copy)
    for _, v in SprinklerData do
        u11[v.SprinklerName] = v;
    end;
end;

function v1.Start(u13) -- Line: 76
    -- upvalues: UserInputService (copy), CutsceneGate (copy), LocalPlayer (copy)
    UserInputService.InputBegan:Connect(function(p14, p15) -- Line: 78
        -- upvalues: u13 (copy)
        u13:OnInput(p14, p15);
    end);
    UserInputService.TouchTapInWorld:Connect(function(p16, p17) -- Line: 87
        -- upvalues: CutsceneGate (ref), u13 (copy)
        if p17 then
            return;
        end;

        if CutsceneGate.IsActive() then
            return;
        end;

        local v18 = u13:GetEquippedTool();

        if not (v18 and v18:GetAttribute("Sprinkler")) then
            return;
        end;

        u13:TryPlace(p16);
    end);
    local Character = LocalPlayer.Character;

    if Character then
        u13:SetupCharacter(Character);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p19) -- Line: 101
        -- upvalues: u13 (copy)
        u13:SetupCharacter(p19);
    end);
end;

function v1.IsTouchInput(p20) -- Line: 107
    -- upvalues: UserInputService (copy)
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled;
end;

function v1.SetupCharacter(u21, p22) -- Line: 111
    p22.ChildAdded:Connect(function(p23) -- Line: 112
        -- upvalues: u21 (copy)
        if p23:IsA("Tool") and p23:GetAttribute("Sprinkler") then
            u21:CreatePreview(p23:GetAttribute("Sprinkler"));
        end;
    end);
    p22.ChildRemoved:Connect(function(p24) -- Line: 118
        -- upvalues: u21 (copy)
        if p24:IsA("Tool") and p24:GetAttribute("Sprinkler") then
            u21:DestroyPreview();
        end;
    end);

    for _, child in p22:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("Sprinkler") then
            u21:CreatePreview(child:GetAttribute("Sprinkler"));
        end;
    end;
end;

function v1.CreatePreview(u25, p26) -- Line: 131
    -- upvalues: Sprinklers (copy), u11 (copy), u6 (ref), Assets (copy), u7 (ref), u9 (ref), TweenService (copy), u3 (copy), u10 (ref), Temporary (copy), u8 (ref), RunService (copy)
    u25:DestroyPreview();

    if u25:IsTouchInput() then
        return;
    end;

    local v27 = Sprinklers:FindFirstChild(p26);
    local v28 = u11[p26];

    if not (v27 and v28) then
        return;
    end;

    u6 = v27:Clone();
    u6.Name = "SprinklerPreview";
    local v29 = Assets.SprinklerRadius:Clone();
    v29.Size = Vector3.new(v28.Radius, 0.5, v28.Radius);
    v29.Anchored = true;
    v29.CanCollide = false;
    v29.CanQuery = false;
    v29.CanTouch = false;
    v29.Parent = u6;
    u7 = v29;
    local SurfaceGui = v29:FindFirstChild("SurfaceGui");

    if SurfaceGui then
        local PrimaryCircle = SurfaceGui:FindFirstChild("PrimaryCircle");

        if PrimaryCircle and PrimaryCircle:IsA("ImageLabel") then
            u9 = TweenService:Create(PrimaryCircle, u3, {
                ImageTransparency = 0.5
            });
            u10 = task.spawn(function() -- Line: 166
                -- upvalues: u7 (ref), PrimaryCircle (copy), SurfaceGui (copy), TweenService (ref)
                while u7 do
                    local u30 = PrimaryCircle:Clone();
                    local v31 = u30:FindFirstChildOfClass("UIScale");

                    if not v31 then
                        v31 = Instance.new("UIScale");
                        v31.Parent = u30;
                    end;

                    u30.Parent = SurfaceGui;
                    v31.Scale = 0;
                    local v32 = TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                    TweenService:Create(v31, v32, {
                        Scale = 1
                    }):Play();
                    local v33 = TweenService:Create(u30, v32, {
                        ImageTransparency = 0
                    });
                    v33:Play();
                    v33.Completed:Once(function() -- Line: 185
                        -- upvalues: TweenService (ref), u30 (copy)
                        local v34 = TweenService:Create(u30, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            ImageTransparency = 1
                        });
                        v34:Play();
                        v34.Completed:Once(function() -- Line: 189
                            -- upvalues: u30 (ref)
                            u30:Destroy();
                        end);
                    end);
                    task.wait(1.1);
                end;
            end);
        end;
    end;

    for _, descendant in u6:GetDescendants() do
        if descendant:IsA("BasePart") then
            if descendant.Transparency == 0 then
                descendant.Transparency = 0.5;
            end;

            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Anchored = true;
        elseif descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false;
        end;
    end;

    u6.Parent = Temporary;
    u8 = RunService.RenderStepped:Connect(function() -- Line: 215
        -- upvalues: u25 (copy)
        u25:UpdatePreview();
    end);
end;

function v1.DestroyPreview(p35) -- Line: 220
    -- upvalues: u10 (ref), u9 (ref), u6 (ref), u7 (ref), u8 (ref)
    if u10 then
        task.cancel(u10);
        u10 = nil;
    end;

    if u9 then
        u9:Cancel();
        u9 = nil;
    end;

    if u6 then
        u6:Destroy();
        u6 = nil;
    end;

    u7 = nil;

    if u8 then
        u8:Disconnect();
        u8 = nil;
    end;
end;

function v1.SetPreviewColor(p36, p37) -- Line: 244
    -- upvalues: u6 (ref), u4 (copy), u5 (copy)
    if not u6 then
        return;
    end;

    local v38 = p37 and u4 or u5;

    for _, descendant in u6:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Color = v38;
        end;
    end;
end;

function v1.IsUsingGamepad(p39) -- Line: 256
    -- upvalues: UserInputService (copy)
    local v40 = UserInputService:GetLastInputType();

    return (v40 == Enum.UserInputType.Gamepad1 or (v40 == Enum.UserInputType.Gamepad2 or v40 == Enum.UserInputType.Gamepad3)) and true or v40 == Enum.UserInputType.Gamepad4;
end;

function v1.GetGamepadPlacementRay(p41) -- Line: 264
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        return HumanoidRootPart.Position + HumanoidRootPart.CFrame.LookVector * 8 + Vector3.new(0, 50, 0), Vector3.new(0, -100, 0);
    end;

    return nil;
end;

function v1.CreatePreviewRaycastParams(p42) -- Line: 279
    -- upvalues: LocalPlayer (copy), Temporary (copy)
    local v43 = RaycastParams.new();
    v43.FilterType = Enum.RaycastFilterType.Exclude;
    local Character = LocalPlayer.Character;
    local v44 = workspace:QueryDescendants("BasePart[Transparency = 1]");
    table.insert(v44, Temporary);

    if Character then
        table.insert(v44, Character);
    end;

    v43.FilterDescendantsInstances = v44;

    return v43;
end;

function v1.IsTooCloseToSprinkler(p45, p46, p47) -- Line: 292
    -- upvalues: u6 (ref), u11 (copy)
    if not p46 then
        return false;
    end;

    for _, descendant in p46:GetDescendants() do
        if descendant:IsA("Model") and (descendant ~= u6 and (u11[descendant.Name] and (descendant.PrimaryPart and (descendant.PrimaryPart.Position - p47).Magnitude < 1))) then
            return true;
        end;
    end;

    return false;
end;

function v1.UpdatePreview(p48) -- Line: 307
    -- upvalues: u6 (ref), UserInputService (copy), CurrentCamera (copy), CollectionService (copy), Temporary (copy), RadiusPreviewHeight (copy), u7 (ref)
    if not u6 then
        return;
    end;

    local v49 = p48:CreateRaycastParams();
    local v50;

    if p48:IsUsingGamepad() then
        local v51, v52 = p48:GetGamepadPlacementRay();

        if not v51 then
            u6.Parent = nil;

            return;
        end;

        v50 = workspace:Raycast(v51, v52, v49);
    else
        local v53 = UserInputService:GetMouseLocation();
        local v54 = CurrentCamera:ViewportPointToRay(v53.X, v53.Y);
        v50 = workspace:Raycast(v54.Origin, v54.Direction * 5000, v49);
    end;

    if not v50 then
        local v55 = p48:CreatePreviewRaycastParams();
        local v56;

        if p48:IsUsingGamepad() then
            local v57, v58 = p48:GetGamepadPlacementRay();

            if not v57 then
                u6.Parent = nil;

                return;
            end;

            v56 = workspace:Raycast(v57, v58, v55);
        else
            local v59 = UserInputService:GetMouseLocation();
            local v60 = CurrentCamera:ViewportPointToRay(v59.X, v59.Y);
            v56 = workspace:Raycast(v60.Origin, v60.Direction * 5000, v55);
        end;

        if not v56 then
            u6.Parent = nil;

            return;
        end;

        u6.Parent = Temporary;
        local Position = v56.Position;
        local X = Position.X;
        local v61 = RadiusPreviewHeight.Get();
        local v62 = Vector3.new(X, v61, Position.Z);

        if u6.PrimaryPart then
            u6:PivotTo(CFrame.new(v62));
        end;

        if u7 then
            u7.CFrame = CFrame.new(v62);
        end;

        p48:SetPreviewColor(false);

        return;
    end;

    local Instance2 = v50.Instance;
    local v63 = p48:GetPlotFromPart(Instance2);
    local v64 = v63 and (CollectionService:HasTag(Instance2, "PlantArea") and Instance2:IsDescendantOf(v63));

    if v64 then
        if v63:GetAttribute("Owner") == nil then
            v64 = false;
        else
            v64 = not p48:IsTooCloseToSprinkler(v63, v50.Position);
        end;
    end;

    u6.Parent = Temporary;
    local Position = v50.Position;
    local X = Position.X;
    local v65 = RadiusPreviewHeight.Get();
    local v66 = Vector3.new(X, v65, Position.Z);

    if u6.PrimaryPart then
        u6:PivotTo(CFrame.new(v66));
    end;

    if u7 then
        u7.CFrame = CFrame.new(v66);
    end;

    p48:SetPreviewColor(v64);
end;

function v1.GetPlayerPlot(p67) -- Line: 388
    -- upvalues: LocalPlayer (copy), Gardens (copy)
    local v68 = LocalPlayer:GetAttribute("PlotId");

    if v68 then
        return Gardens:FindFirstChild("Plot" .. v68);
    end;

    return nil;
end;

function v1.GetPlotFromPart(p69, p70) -- Line: 394
    -- upvalues: Gardens (copy)
    while p70 do
        if p70.Parent == Gardens and string.match(p70.Name, "^Plot%d+$") then
            return p70;
        end;

        p70 = p70.Parent;

        if p70 == workspace then
            break;
        end;
    end;

    return nil;
end;

function v1.GetPlotId(p71, p72) -- Line: 406
    return tonumber(string.match(p72.Name, "%d+"));
end;

function v1.GetEquippedTool(p73) -- Line: 412
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character then
        return Character:FindFirstChildWhichIsA("Tool");
    end;

    return nil;
end;

function v1.CreateRaycastParams(p74) -- Line: 418
    local v75 = RaycastParams.new();
    v75.FilterType = Enum.RaycastFilterType.Include;
    v75.FilterDescendantsInstances = workspace.Gardens:QueryDescendants("BasePart.PlantArea");

    return v75;
end;

function v1.OnInput(p76, p77, p78) -- Line: 428
    -- upvalues: CutsceneGate (copy)
    if p78 then
        return;
    end;

    if CutsceneGate.IsActive() then
        return;
    end;

    if p77.UserInputType ~= Enum.UserInputType.MouseButton1 and p77.KeyCode ~= Enum.KeyCode.ButtonR2 then
        return;
    end;

    p76:TryPlace();
end;

function v1.TryPlace(p79, p80) -- Line: 444
    -- upvalues: u2 (ref), UserInputService (copy), CurrentCamera (copy), CollectionService (copy), Networking (copy), LocalPlayer (copy), SoundService (copy)
    local v81 = os.clock();

    if v81 - u2 < 0.5 then
        return false;
    end;

    local v82 = p79:GetEquippedTool();

    if not v82 then
        return false;
    end;

    local v83 = v82:GetAttribute("Sprinkler");

    if not v83 then
        return false;
    end;

    local v84 = p79:CreateRaycastParams();
    local v85;

    if p79:IsUsingGamepad() then
        local v86, v87 = p79:GetGamepadPlacementRay();

        if not v86 then
            return false;
        end;

        v85 = workspace:Raycast(v86, v87, v84);
    else
        local v88 = p80 or UserInputService:GetMouseLocation();
        local v89 = CurrentCamera:ViewportPointToRay(v88.X, v88.Y);
        v85 = workspace:Raycast(v89.Origin, v89.Direction * 5000, v84);
    end;

    if not v85 then
        return false;
    end;

    local Instance2 = v85.Instance;

    if not CollectionService:HasTag(Instance2, "PlantArea") then
        return false;
    end;

    local v90 = p79:GetPlotFromPart(Instance2);

    if not v90 then
        return false;
    end;

    if not Instance2:IsDescendantOf(v90) then
        return false;
    end;

    if not v90:GetAttribute("Owner") then
        return false;
    end;

    local v91 = p79:GetPlotId(v90);

    if not v91 then
        return false;
    end;

    if p79:IsTooCloseToSprinkler(v90, v85.Position) then
        return false;
    end;

    u2 = v81;
    Networking.Place.PlaceSprinkler:Fire(v85.Position, v83, v82, v91);
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if Character then
        local Sound = Instance.new("Sound");
        Sound.SoundId = "rbxassetid://135948019584556";
        Sound.SoundGroup = SoundService:FindFirstChild("SFXGroup");
        Sound.Parent = Character;
        Sound:Play();
        game.Debris:AddItem(Sound, 3);
    end;

    return true;
end;

return v1;