-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 1
};
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = workspace.CurrentCamera;
local Robin = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Pets"):WaitForChild("Robin");
local Temporary = workspace:WaitForChild("Temporary");
local u2 = Color3.fromRGB(100, 255, 100);
local u3 = Color3.fromRGB(255, 100, 100);
local u4 = 0;
local u5 = nil;
local u6 = nil;
local u7 = false;

local function raycastSkipTransparent(p8, p9, p10) -- Line: 36
    for _ = 1, 10 do
        local v11 = workspace:Raycast(p8, p9, p10);

        if not v11 then
            return nil;
        end;

        if v11.Instance.Transparency < 1 then
            return v11;
        end;

        local v12 = table.clone(p10.FilterDescendantsInstances);
        table.insert(v12, v11.Instance);
        p10.FilterDescendantsInstances = v12;
    end;

    return nil;
end;

function v1.Init(p13) -- Line: 51
end;

function v1.Start(u14) -- Line: 54
    -- upvalues: UserInputService (copy), LocalPlayer (copy)
    UserInputService.InputBegan:Connect(function(p15, p16) -- Line: 55
        -- upvalues: u14 (copy)
        u14:OnInput(p15, p16);
    end);
    local Character = LocalPlayer.Character;

    if Character then
        u14:SetupCharacter(Character);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p17) -- Line: 61
        -- upvalues: u14 (copy)
        u14:SetupCharacter(p17);
    end);
end;

function v1.SetupCharacter(u18, p19) -- Line: 66
    p19.ChildAdded:Connect(function(p20) -- Line: 67
        -- upvalues: u18 (copy)
        if p20:IsA("Tool") and p20:GetAttribute("Bird") then
            u18:EnterPlacingMode();
        end;
    end);
    p19.ChildRemoved:Connect(function(p21) -- Line: 72
        -- upvalues: u18 (copy)
        if p21:IsA("Tool") and p21:GetAttribute("Bird") then
            u18:ExitPlacingMode();
        end;
    end);

    for _, child in p19:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("Bird") then
            u18:EnterPlacingMode();
        end;
    end;
end;

function v1.EnterPlacingMode(p22) -- Line: 84
    -- upvalues: u7 (ref)
    if u7 then
        return;
    end;

    u7 = true;
    p22:CreatePreview();
end;

function v1.ExitPlacingMode(p23) -- Line: 90
    -- upvalues: u7 (ref)
    u7 = false;
    p23:DestroyPreview();
end;

function v1.CreatePreview(u24) -- Line: 95
    -- upvalues: Robin (copy), Temporary (copy), u5 (ref), u6 (ref), RunService (copy)
    u24:DestroyPreview();
    local v25 = Robin:Clone();
    v25.Name = "BirdPreview";

    for _, descendant in v25:GetDescendants() do
        if descendant:IsA("BasePart") then
            if descendant.Transparency == 0 then
                descendant.Transparency = 0.5;
            end;

            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Anchored = true;
        elseif descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or descendant:IsA("Beam")) then
            descendant.Enabled = false;
        end;
    end;

    v25.Parent = Temporary;
    u5 = v25;
    u6 = RunService.RenderStepped:Connect(function() -- Line: 116
        -- upvalues: u24 (copy)
        debug.profilebegin("Controllers/BirdController/PreviewUpdate");
        u24:UpdatePreview();
        debug.profileend();
    end);
end;

function v1.DestroyPreview(p26) -- Line: 123
    -- upvalues: u6 (ref), u5 (ref)
    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;

    if u5 then
        u5:Destroy();
        u5 = nil;
    end;
end;

function v1.SetPreviewColor(p27, p28) -- Line: 134
    -- upvalues: u5 (ref), u2 (copy), u3 (copy)
    if not u5 then
        return;
    end;

    local v29 = p28 and u2 or u3;

    for _, descendant in u5:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Color = v29;
        end;
    end;
end;

function v1.IsUsingGamepad(p30) -- Line: 144
    -- upvalues: UserInputService (copy)
    local v31 = UserInputService:GetLastInputType();

    return (v31 == Enum.UserInputType.Gamepad1 or (v31 == Enum.UserInputType.Gamepad2 or v31 == Enum.UserInputType.Gamepad3)) and true or v31 == Enum.UserInputType.Gamepad4;
end;

function v1.GetGamepadPlacementRay(p32) -- Line: 152
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return nil, nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        return HumanoidRootPart.Position + HumanoidRootPart.CFrame.LookVector * 8 + Vector3.new(0, 50, 0), Vector3.new(0, -100, 0);
    end;

    return nil, nil;
end;

function v1.CreateRaycastParams(p33) -- Line: 162
    -- upvalues: LocalPlayer (copy), Temporary (copy), u5 (ref)
    local v34 = RaycastParams.new();
    v34.FilterType = Enum.RaycastFilterType.Exclude;
    local Character = LocalPlayer.Character;
    local v35 = { Temporary };

    if u5 then
        table.insert(v35, u5);
    end;

    if Character then
        table.insert(v35, Character);
    end;

    v34.FilterDescendantsInstances = v35;

    return v34;
end;

function v1.IsValidPlacement(p36, p37) -- Line: 173
    -- upvalues: CollectionService (copy)
    local v38 = CollectionService:GetTagged("GardenTotalArea");

    if #v38 == 0 then
        return false;
    end;

    local v39 = RaycastParams.new();
    v39.FilterType = Enum.RaycastFilterType.Include;
    v39.FilterDescendantsInstances = v38;

    return workspace:Raycast(p37 + Vector3.new(0, 50, 0), Vector3.new(0, -100, 0), v39) ~= nil;
end;

function v1.UpdatePreview(p40) -- Line: 187
    -- upvalues: u5 (ref), raycastSkipTransparent (copy), UserInputService (copy), CurrentCamera (copy), Temporary (copy)
    if not u5 then
        return;
    end;

    local v41 = p40:CreateRaycastParams();
    local v42;

    if p40:IsUsingGamepad() then
        local v43, v44 = p40:GetGamepadPlacementRay();

        if not (v43 and v44) then
            u5.Parent = nil;

            return;
        end;

        v42 = raycastSkipTransparent(v43, v44, v41);
    else
        local v45 = UserInputService:GetMouseLocation();
        local v46 = CurrentCamera:ViewportPointToRay(v45.X, v45.Y);
        v42 = raycastSkipTransparent(v46.Origin, v46.Direction * 5000, v41);
    end;

    if not v42 then
        u5.Parent = nil;

        return;
    end;

    u5.Parent = Temporary;
    local Position = v42.Position;
    local v47 = Position + Vector3.new(0, 14, 0);

    if u5.PrimaryPart then
        u5:PivotTo(CFrame.new(v47));
    end;

    p40:SetPreviewColor(p40:IsValidPlacement(Position));
end;

function v1.GetEquippedTool(p48) -- Line: 223
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character then
        return Character:FindFirstChildWhichIsA("Tool");
    end;

    return nil;
end;

function v1.OnInput(p49, p50, p51) -- Line: 229
    -- upvalues: u7 (ref), u4 (ref), raycastSkipTransparent (copy), CurrentCamera (copy), Networking (copy), LocalPlayer (copy), SoundService (copy)
    if p51 then
        return;
    end;

    if not u7 then
        return;
    end;

    if p50.UserInputType ~= Enum.UserInputType.MouseButton1 and p50.UserInputType ~= Enum.UserInputType.Touch and p50.KeyCode ~= Enum.KeyCode.ButtonR2 then
        return;
    end;

    local v52 = os.clock();

    if v52 - u4 < 0.5 then
        return;
    end;

    local v53 = p49:GetEquippedTool();

    if not v53 then
        return;
    end;

    local v54 = v53:GetAttribute("Bird");

    if not v54 then
        return;
    end;

    local v55 = p49:CreateRaycastParams();
    local v56;

    if p49:IsUsingGamepad() then
        local v57, v58 = p49:GetGamepadPlacementRay();

        if not (v57 and v58) then
            return;
        end;

        v56 = raycastSkipTransparent(v57, v58, v55);
    else
        local Position = p50.Position;
        local v59 = CurrentCamera:ScreenPointToRay(Position.X, Position.Y);
        v56 = raycastSkipTransparent(v59.Origin, v59.Direction * 5000, v55);
    end;

    if not v56 then
        return;
    end;

    if not p49:IsValidPlacement(v56.Position) then
        return;
    end;

    u4 = v52;
    Networking.Place.PlaceBird:Fire(v56.Position, v54, v53);
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
end;

return v1;