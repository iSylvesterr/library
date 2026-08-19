-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 4
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local GardenSyncController = require(script.Parent.GardenSyncController);
local SprinklerData = require(ReplicatedStorage.SharedModules.SprinklerData);
local RadiusPreviewHeight = require(ReplicatedStorage.ClientModules.RadiusPreviewHeight);
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = workspace.CurrentCamera;
local Gardens = workspace:WaitForChild("Gardens");
local Temporary = workspace:WaitForChild("Temporary");
local Assets = ReplicatedStorage.Assets;
local Sprinklers = Assets.Sprinklers;
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = 0;
local u6 = nil;
local u7 = nil;
local u8 = nil;

function v1.Init(p9) -- Line: 34
    -- upvalues: SprinklerData (copy), u3 (copy)
    for _, v in SprinklerData do
        u3[v.SprinklerName] = v;
    end;
end;

function v1.Start(u10) -- Line: 40
    -- upvalues: GardenSyncController (copy), RunService (copy)
    GardenSyncController:OnSprinklerAdded(function(p11, p12, p13) -- Line: 41
        -- upvalues: u10 (copy)
        u10:SpawnSprinklerFromData(p11, p12, p13);
    end);
    GardenSyncController:OnSprinklerRemoved(function(p14, p15) -- Line: 45
        -- upvalues: u10 (copy)
        u10:RemoveSprinklerById(p14, p15);
    end);
    RunService.Heartbeat:Connect(function(p16) -- Line: 49
        -- upvalues: u10 (copy)
        debug.profilebegin("Controllers/SprinklerVisualizerController/Heartbeat");
        u10:UpdateSprinklerTimers();
        u10:UpdateSprinklerSpins(p16);
        u10:UpdateHoverPreview();
        debug.profileend();
    end);
end;

function v1.GetPlayerPlot(p17, p18) -- Line: 58
    -- upvalues: Players (copy), Gardens (copy)
    local v19 = Players:GetPlayerByUserId(p18);

    if not v19 then
        return nil;
    end;

    local v20 = v19:GetAttribute("PlotId");

    if v20 then
        return Gardens:FindFirstChild("Plot" .. v20);
    end;

    return nil;
end;

function v1.GetSpawnPoint(p21, p22) -- Line: 68
    local v23 = p21:GetPlayerPlot(p22);

    if v23 then
        return v23:FindFirstChild("SpawnPoint");
    end;

    return nil;
end;

function v1.GetSprinklersFolder(p24, p25) -- Line: 75
    local v26 = p24:GetPlayerPlot(p25);

    if not v26 then
        return nil;
    end;

    local Sprinklers2 = v26:FindFirstChild("Sprinklers");

    if not Sprinklers2 then
        Sprinklers2 = Instance.new("Folder");
        Sprinklers2.Name = "Sprinklers";
        Sprinklers2.Parent = v26;
    end;

    return Sprinklers2;
end;

function v1.GetSprinklerData(p27, p28) -- Line: 88
    -- upvalues: u3 (copy)
    return u3[p28];
end;

function v1.CreateSprinklerTimerUI(p29, p30) -- Line: 92
    local v31 = script.SprinklerTimerUI:Clone();
    v31.Parent = p30;

    return v31;
end;

function v1.UpdateSprinklerTimers(p32) -- Line: 98
    -- upvalues: u2 (copy), u4 (copy)
    local v33 = workspace:GetServerTimeNow();

    for i, v in u2 do
        if v and v.Parent then
            local v34 = u4[i];

            if v34 then
                local v35 = math.clamp(v34.Lifetime - (v33 - v34.PlacedAt), 0, v34.Lifetime);

                if v35 <= 0 then
                    v:Destroy();
                    u2[i] = nil;
                    u4[i] = nil;
                else
                    local v36 = math.floor(v35 / 60);
                    local v37 = v35 % 60;
                    local SprinklerTimerUI = v:FindFirstChild("SprinklerTimerUI");

                    if SprinklerTimerUI and SprinklerTimerUI:IsA("BillboardGui") then
                        local v38 = SprinklerTimerUI:FindFirstChildOfClass("TextLabel");

                        if v38 then
                            v38.Text = string.format("%d:%02d", v36, v37);
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function v1.UpdateSprinklerSpins(p39, p40) -- Line: 133
    -- upvalues: u5 (ref), u2 (copy)
    u5 = u5 + p40;

    if u5 < 0.2 then
        return;
    end;

    u5 = 0;
    local v41 = CFrame.Angles(0, 0.3141592653589793, 0);

    for _, v in u2 do
        if v and v.Parent then
            v:PivotTo(v:GetPivot() * v41);
        end;
    end;
end;

function v1.SpawnSprinklerFromData(p42, p43, p44, p45) -- Line: 151
    -- upvalues: u2 (copy), u4 (copy), Sprinklers (copy), SoundService (copy)
    local v46 = p42:GetSpawnPoint(p43);

    if not v46 then
        return;
    end;

    local v47 = p42:GetSprinklersFolder(p43);

    if not v47 then
        return;
    end;

    local SprinklerName = p45.SprinklerName;

    if not SprinklerName then
        return;
    end;

    local v48 = `{p43}_{p44}`;

    if u2[v48] then
        u2[v48]:Destroy();
        u2[v48] = nil;
        u4[v48] = nil;
    end;

    local v49 = Vector3.new(p45.Positions.PosX, p45.Positions.PosY, p45.Positions.PosZ);
    local Rotation = p45.Positions.Rotation;
    local v50 = v46.CFrame:PointToWorldSpace(v49);
    local v51 = select(2, v46.CFrame:ToEulerAnglesYXZ());
    local v52 = Rotation + math.deg(v51);
    local v53 = CFrame.new(v50) * CFrame.Angles(0, math.rad(v52), 0);
    local v54 = Sprinklers:FindFirstChild(SprinklerName);

    if not v54 then
        return;
    end;

    local v55 = v54:Clone();
    v55.Name = v48;
    v55:SetAttribute("SprinklerId", p44);
    v55:SetAttribute("UserId", p43);
    v55:SetAttribute("SprinklerName", SprinklerName);
    v55.Parent = v47;
    v55:PivotTo(v53);
    local v56 = p42:GetSprinklerData(SprinklerName);

    if v56 then
        if workspace:GetServerTimeNow() - p45.PlacedAt >= v56.Lifetime then
            v55:Destroy();

            return;
        end;

        u4[v48] = {
            PlacedAt = p45.PlacedAt,
            Lifetime = v56.Lifetime
        };
        p42:CreateSprinklerTimerUI(v55);
    end;

    local v57 = v55.PrimaryPart or v55:FindFirstChildWhichIsA("BasePart");

    if v57 then
        local Sound = Instance.new("Sound");
        Sound.SoundId = "rbxassetid://76520945762958";
        Sound.Volume = 0.5;
        Sound.RollOffMaxDistance = 100;
        Sound.Looped = true;
        Sound.SoundGroup = SoundService:FindFirstChild("SFXGroup");
        Sound.Parent = v57;
        Sound:Play();
    end;

    u2[v48] = v55;
end;

function v1.RemoveSprinklerById(p58, p59, p60) -- Line: 223
    -- upvalues: u2 (copy), u4 (copy)
    local v61 = `{p59}_{p60}`;
    local v62 = u2[v61];

    if v62 then
        v62:Destroy();
        u2[v61] = nil;
        u4[v61] = nil;
    end;
end;

function v1.GetSprinklerFromPart(p63, p64) -- Line: 234
    -- upvalues: u2 (copy)
    for _, v in u2 do
        if v and (v.Parent and p64:IsDescendantOf(v)) then
            return v;
        end;
    end;

    return nil;
end;

function v1.UpdateHoverPreview(p65) -- Line: 243
    -- upvalues: u8 (ref), UserInputService (copy), CurrentCamera (copy), Temporary (copy), LocalPlayer (copy)
    if u8 and not u8.Parent then
        p65:DestroyHoverPreview();
    end;

    local v66 = UserInputService:GetMouseLocation();
    local v67 = CurrentCamera:ViewportPointToRay(v66.X, v66.Y);
    local v68 = RaycastParams.new();
    v68.FilterType = Enum.RaycastFilterType.Exclude;
    local v69 = { Temporary };
    local Character = LocalPlayer.Character;

    if Character then
        table.insert(v69, Character);
    end;

    v68.FilterDescendantsInstances = v69;
    local v70 = nil;

    for _ = 1, 10 do
        local v71 = workspace:Raycast(v67.Origin, v67.Direction * 5000, v68);

        if not v71 then
            break;
        end;

        local Instance2 = v71.Instance;

        if not Instance2 then
            break;
        end;

        local v72 = p65:GetSprinklerFromPart(Instance2);

        if v72 then
            v70 = v72;
            break;
        end;

        if Instance2.Transparency < 0.9 then
            break;
        end;

        table.insert(v69, Instance2);
        v68.FilterDescendantsInstances = v69;
    end;

    if v70 == u8 then
        return;
    end;

    p65:DestroyHoverPreview();

    if v70 then
        p65:CreateHoverPreview(v70);
    end;
end;

function v1.CreateHoverPreview(p73, p74) -- Line: 303
    -- upvalues: u8 (ref), u3 (copy), Assets (copy), RadiusPreviewHeight (copy), Temporary (copy), u6 (ref), u7 (ref), TweenService (copy)
    u8 = p74;
    local v75 = u3[p74:GetAttribute("SprinklerName")];

    if not v75 then
        return;
    end;

    local v76 = Assets.SprinklerRadius:Clone();
    v76.Size = Vector3.new(v75.Radius, 0.5, v75.Radius);
    v76.Anchored = true;
    v76.CanCollide = false;
    v76.CanQuery = false;
    v76.CanTouch = false;
    local Position = p74:GetPivot().Position;
    local new = CFrame.new;
    local X = Position.X;
    local v77 = RadiusPreviewHeight.Get();
    v76.CFrame = new((Vector3.new(X, v77, Position.Z)));
    v76.Parent = Temporary;
    u6 = v76;
    local SurfaceGui = v76:FindFirstChild("SurfaceGui");

    if not SurfaceGui then
        return;
    end;

    local PrimaryCircle = SurfaceGui:FindFirstChild("PrimaryCircle");

    if not (PrimaryCircle and PrimaryCircle:IsA("ImageLabel")) then
        return;
    end;

    u7 = task.spawn(function() -- Line: 328
        -- upvalues: u6 (ref), PrimaryCircle (copy), SurfaceGui (copy), TweenService (ref)
        while u6 and u6.Parent do
            local u78 = PrimaryCircle:Clone();
            local v79 = u78:FindFirstChildOfClass("UIScale");

            if not v79 then
                v79 = Instance.new("UIScale");
                v79.Parent = u78;
            end;

            u78.Parent = SurfaceGui;
            v79.Scale = 0;
            local v80 = TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            TweenService:Create(v79, v80, {
                Scale = 1
            }):Play();
            local v81 = TweenService:Create(u78, v80, {
                ImageTransparency = 0
            });
            v81:Play();
            v81.Completed:Once(function() -- Line: 346
                -- upvalues: TweenService (ref), u78 (copy)
                local v82 = TweenService:Create(u78, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    ImageTransparency = 1
                });
                v82:Play();
                v82.Completed:Once(function() -- Line: 350
                    -- upvalues: u78 (ref)
                    u78:Destroy();
                end);
            end);
            task.wait(1.1);
        end;
    end);
end;

function v1.DestroyHoverPreview(p83) -- Line: 360
    -- upvalues: u7 (ref), u6 (ref), u8 (ref)
    if u7 then
        task.cancel(u7);
        u7 = nil;
    end;

    if u6 then
        u6:Destroy();
        u6 = nil;
    end;

    u8 = nil;
end;

return v1;