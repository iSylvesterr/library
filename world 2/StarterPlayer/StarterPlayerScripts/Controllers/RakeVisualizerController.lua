-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 4
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local GardenSyncController = require(script.Parent.GardenSyncController);
local RakeData = require(ReplicatedStorage.SharedModules.RakeData);
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local RadiusPreviewHeight = require(ReplicatedStorage.ClientModules.RadiusPreviewHeight);
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = workspace.CurrentCamera;
local Gardens = workspace:WaitForChild("Gardens");
local Temporary = workspace:WaitForChild("Temporary");
local Assets = ReplicatedStorage.Assets;
local Rakes = Assets.Rakes;
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = nil;
local u6 = nil;
local u7 = nil;

function v1.Init(p8) -- Line: 30
    -- upvalues: RakeData (copy), u3 (copy)
    for _, v in RakeData do
        u3[v.RakeName] = v;
    end;
end;

function v1.Start(u9) -- Line: 36
    -- upvalues: GardenSyncController (copy), Networking (copy), RunService (copy)
    GardenSyncController:OnRakeAdded(function(p10, p11, p12) -- Line: 37
        -- upvalues: u9 (copy)
        u9:SpawnRakeFromData(p10, p11, p12);
    end);
    GardenSyncController:OnRakeRemoved(function(p13, p14) -- Line: 41
        -- upvalues: u9 (copy)
        u9:RemoveRakeById(p13, p14);
    end);
    Networking.Place.RakeActivated.OnClientEvent:Connect(function(p15, p16) -- Line: 45
        -- upvalues: u9 (copy)
        u9:PlayRakeActivatedFx(p15, p16);
    end);
    RunService.Heartbeat:Connect(function() -- Line: 49
        -- upvalues: u9 (copy)
        debug.profilebegin("Controllers/RakeVisualizerController/Heartbeat");
        u9:UpdateRakeTimers();
        u9:UpdateHoverPreview();
        debug.profileend();
    end);
end;

function v1.GetPlayerPlot(p17, p18) -- Line: 57
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

function v1.GetSpawnPoint(p21, p22) -- Line: 72
    local v23 = p21:GetPlayerPlot(p22);

    if v23 then
        return v23:FindFirstChild("SpawnPoint");
    end;

    return nil;
end;

function v1.GetRakesFolder(p24, p25) -- Line: 82
    local v26 = p24:GetPlayerPlot(p25);

    if not v26 then
        return nil;
    end;

    local Rakes2 = v26:FindFirstChild("Rakes");

    if not Rakes2 then
        Rakes2 = Instance.new("Folder");
        Rakes2.Name = "Rakes";
        Rakes2.Parent = v26;
    end;

    return Rakes2;
end;

function v1.GetRakeData(p27, p28) -- Line: 97
    -- upvalues: u3 (copy)
    return u3[p28];
end;

function v1.CreateRakeTimerUI(p29, p30) -- Line: 101
    local v31 = script.RakeTimerUI:Clone();
    v31.Parent = p30;

    return v31;
end;

function v1.UpdateRakeTimers(p32) -- Line: 107
    -- upvalues: u2 (copy), u4 (copy)
    local v33 = workspace:GetServerTimeNow();
    local v34 = {};

    for i, v in u2 do
        if v and v.Parent then
            local v35 = u4[i];

            if v35 then
                local v36 = math.clamp(v35.Lifetime - (v33 - v35.PlacedAt), 0, v35.Lifetime);

                if v36 <= 0 then
                    table.insert(v34, i);
                else
                    local v37 = math.floor(v36 / 60);
                    local v38 = v36 % 60;
                    local RakeTimerUI = v:FindFirstChild("RakeTimerUI");

                    if RakeTimerUI and RakeTimerUI:IsA("BillboardGui") then
                        local v39 = RakeTimerUI:FindFirstChildOfClass("TextLabel");

                        if v39 then
                            v39.Text = string.format("%d:%02d", v37, v38);
                        end;
                    end;
                end;
            end;
        end;
    end;

    for _, v in v34 do
        local v40 = u2[v];

        if v40 then
            v40:Destroy();
        end;

        u2[v] = nil;
        u4[v] = nil;
    end;
end;

function v1.SpawnRakeFromData(p41, p42, p43, p44) -- Line: 152
    -- upvalues: u2 (copy), u4 (copy), Rakes (copy)
    local v45 = p41:GetSpawnPoint(p42);

    if not v45 then
        return;
    end;

    local v46 = p41:GetRakesFolder(p42);

    if not v46 then
        return;
    end;

    local RakeName = p44.RakeName;

    if not RakeName then
        return;
    end;

    local v47 = p41:GetRakeData(RakeName);

    if v47 and (p44.PlacedAt and workspace:GetServerTimeNow() - p44.PlacedAt >= (v47.Lifetime or (1 / 0))) then
        return;
    end;

    local v48 = `{p42}_{p43}`;

    if u2[v48] then
        u2[v48]:Destroy();
        u2[v48] = nil;
        u4[v48] = nil;
    end;

    local v49 = Vector3.new(p44.Positions.PosX, p44.Positions.PosY, p44.Positions.PosZ);
    local v50 = p44.Positions.Rotation or 0;
    local v51 = v45.CFrame:PointToWorldSpace(v49);
    local _, v52, _ = v45.CFrame:ToEulerAnglesYXZ();
    local v53 = math.rad(v50) + v52;
    local v54 = CFrame.new(v51) * CFrame.Angles(0, v53, 0);
    local v55 = Rakes:FindFirstChild(RakeName) or Rakes:FindFirstChild("Rake");

    if not v55 then
        return;
    end;

    local v56 = v55:Clone();
    local v57 = v47 and v47.Scale or 1;

    if v57 ~= 1 then
        v56:ScaleTo(v56:GetScale() * v57);
    end;

    v56.Name = v48;
    v56:SetAttribute("RakeId", p43);
    v56:SetAttribute("UserId", p42);
    v56:SetAttribute("RakeName", RakeName);
    v56.Parent = v46;
    v56:PivotTo(v54 * CFrame.Angles(0, 3.141592653589793, 0));

    for _, descendant in v56:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanTouch = false;
        end;
    end;

    local Part = Instance.new("Part");
    Part.Name = "HoverDetection";
    Part.Size = Vector3.new(3, 2, 3);
    Part.Transparency = 1;
    Part.CanCollide = false;
    Part.CanTouch = false;
    Part.CanQuery = true;
    Part.Anchored = true;
    Part.CFrame = v54;
    Part.Parent = v56;
    local v58 = p41:GetRakeData(RakeName);
    local v59 = (v58 and (v58.Radius or 7) or 7) * 2;
    local Part2 = Instance.new("Part");
    Part2.Name = "TouchHitbox";
    Part2.Shape = Enum.PartType.Cylinder;
    Part2.Size = Vector3.new(6, v59, v59);
    Part2.CFrame = CFrame.new(v51) * CFrame.Angles(0, 0, 1.5707963267948966);
    Part2.Transparency = 1;
    Part2.CanCollide = false;
    Part2.CanTouch = true;
    Part2.CanQuery = false;
    Part2.Anchored = true;
    Part2.Parent = v56;

    if v58 then
        u4[v48] = {
            PlacedAt = p44.PlacedAt,
            Lifetime = v58.Lifetime
        };
        p41:CreateRakeTimerUI(v56);
    end;

    u2[v48] = v56;
end;

function v1.RemoveRakeById(p60, p61, p62) -- Line: 268
    -- upvalues: u2 (copy), u4 (copy)
    local v63 = `{p61}_{p62}`;
    local v64 = u2[v63];

    if v64 then
        v64:Destroy();
        u2[v63] = nil;
        u4[v63] = nil;
    end;
end;

function v1.FindModelByRakeId(p65, p66) -- Line: 282
    -- upvalues: u2 (copy)
    for _, v in u2 do
        if v and (v.Parent and v:GetAttribute("RakeId") == p66) then
            return v;
        end;
    end;

    return nil;
end;

function v1.GetRakeFromPart(p67, p68) -- Line: 291
    -- upvalues: u2 (copy)
    for _, v in u2 do
        if v and (v.Parent and p68:IsDescendantOf(v)) then
            return v;
        end;
    end;

    return nil;
end;

function v1.PlayRakeActivatedFx(p69, p70, p71) -- Line: 303
    -- upvalues: TweenService (copy)
    local v72 = p69:FindModelByRakeId(p70);

    if not v72 then
        return;
    end;

    local RakeModel = v72:FindFirstChild("RakeModel");
    local v73;

    if RakeModel then
        v73 = RakeModel:FindFirstChild("Hitbox");
    else
        v73 = RakeModel;
    end;

    if v73 then
        local Thud = v73:FindFirstChild("Thud");

        if Thud then
            Thud.PlaybackSpeed = math.random(90, 110) / 100;
            Thud.TimePosition = 0;
            Thud:Play();
        end;

        local VFX = v73:FindFirstChild("VFX");

        if VFX and VFX:FindFirstChild("Break") then
            VFX.Break:Emit(2);
        end;
    end;

    if RakeModel then
        local u74 = RakeModel:GetPivot();
        local _, v75, _ = u74:ToOrientation();
        local u76 = CFrame.new(u74.Position) * CFrame.Angles(0, v75 + 3.141592653589793, 0) * CFrame.Angles(-1.5707963267948966, 0, 0);
        local NumberValue = Instance.new("NumberValue");
        NumberValue.Value = 0;
        local u77 = nil;
        u77 = NumberValue.Changed:Connect(function() -- Line: 337
            -- upvalues: RakeModel (copy), u77 (ref), NumberValue (copy), u74 (copy), u76 (copy)
            if RakeModel and RakeModel.Parent then
                RakeModel:PivotTo(u74:Lerp(u76, NumberValue.Value));

                return;
            end;

            u77:Disconnect();
            NumberValue:Destroy();
        end);
        local v78 = TweenService:Create(NumberValue, TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
            Value = 1
        });
        v78:Play();
        v78.Completed:Once(function() -- Line: 349
            -- upvalues: TweenService (ref), NumberValue (copy), u77 (ref)
            task.wait(2);
            local v79 = TweenService:Create(NumberValue, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Value = 0
            });
            v79:Play();
            v79.Completed:Once(function() -- Line: 354
                -- upvalues: u77 (ref), NumberValue (ref)
                u77:Disconnect();
                NumberValue:Destroy();
            end);
        end);
    end;
end;

function v1.UpdateHoverPreview(p80) -- Line: 365
    -- upvalues: u7 (ref), UserInputService (copy), CurrentCamera (copy), Temporary (copy), LocalPlayer (copy)
    if u7 and not u7.Parent then
        p80:DestroyHoverPreview();
    end;

    local v81 = UserInputService:GetMouseLocation();
    local v82 = CurrentCamera:ViewportPointToRay(v81.X, v81.Y);
    local v83 = RaycastParams.new();
    v83.FilterType = Enum.RaycastFilterType.Exclude;
    local v84 = { Temporary };
    local Character = LocalPlayer.Character;

    if Character then
        table.insert(v84, Character);
    end;

    v83.FilterDescendantsInstances = v84;
    local v85 = nil;

    for _ = 1, 10 do
        v85 = workspace:Raycast(v82.Origin, v82.Direction * 5000, v83);

        if not v85 then
            break;
        end;

        local Instance2 = v85.Instance;

        if not Instance2 or (Instance2.Transparency < 0.9 or Instance2.Name == "HoverDetection") then
            break;
        end;

        table.insert(v84, Instance2);
        v83.FilterDescendantsInstances = v84;
    end;

    local v86;

    if v85 then
        v86 = p80:GetRakeFromPart(v85.Instance);
    else
        v86 = nil;
    end;

    if v86 == u7 then
        return;
    end;

    p80:DestroyHoverPreview();

    if v86 then
        p80:CreateHoverPreview(v86);
    end;
end;

function v1.CreateHoverPreview(p87, p88) -- Line: 423
    -- upvalues: u7 (ref), u3 (copy), Assets (copy), RadiusPreviewHeight (copy), Temporary (copy), u5 (ref), u6 (ref), TweenService (copy)
    u7 = p88;
    local v89 = u3[p88:GetAttribute("RakeName")];

    if not v89 then
        return;
    end;

    local v90 = Assets.SprinklerRadius:Clone();
    v90.Size = Vector3.new(v89.Radius * 2, 0.5, v89.Radius * 2);
    v90.Anchored = true;
    v90.CanCollide = false;
    v90.CanQuery = false;
    v90.CanTouch = false;
    local Position = p88:GetPivot().Position;
    local new = CFrame.new;
    local X = Position.X;
    local v91 = RadiusPreviewHeight.Get();
    v90.CFrame = new((Vector3.new(X, v91, Position.Z)));
    v90.Parent = Temporary;
    u5 = v90;
    local SurfaceGui = v90:FindFirstChild("SurfaceGui");

    if SurfaceGui then
        local PrimaryCircle = SurfaceGui:FindFirstChild("PrimaryCircle");

        if PrimaryCircle and PrimaryCircle:IsA("ImageLabel") then
            u6 = task.spawn(function() -- Line: 446
                -- upvalues: u5 (ref), PrimaryCircle (copy), SurfaceGui (copy), TweenService (ref)
                while u5 and u5.Parent do
                    local u92 = PrimaryCircle:Clone();
                    local v93 = u92:FindFirstChildOfClass("UIScale");

                    if not v93 then
                        v93 = Instance.new("UIScale");
                        v93.Parent = u92;
                    end;

                    u92.Parent = SurfaceGui;
                    v93.Scale = 0;
                    local v94 = TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                    TweenService:Create(v93, v94, {
                        Scale = 1
                    }):Play();
                    local v95 = TweenService:Create(u92, v94, {
                        ImageTransparency = 0
                    });
                    v95:Play();
                    v95.Completed:Once(function() -- Line: 464
                        -- upvalues: TweenService (ref), u92 (copy)
                        local v96 = TweenService:Create(u92, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            ImageTransparency = 1
                        });
                        v96:Play();
                        v96.Completed:Once(function() -- Line: 468
                            -- upvalues: u92 (ref)
                            u92:Destroy();
                        end);
                    end);
                    task.wait(1.1);
                end;
            end);
        end;
    end;
end;

function v1.DestroyHoverPreview(p97) -- Line: 480
    -- upvalues: u6 (ref), u5 (ref), u7 (ref)
    if u6 then
        task.cancel(u6);
        u6 = nil;
    end;

    if u5 then
        u5:Destroy();
        u5 = nil;
    end;

    u7 = nil;
end;

return v1;