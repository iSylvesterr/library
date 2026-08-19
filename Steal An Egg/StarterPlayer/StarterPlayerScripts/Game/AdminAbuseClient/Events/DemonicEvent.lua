-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local HideImportantUI = require(ReplicatedStorage.Library.Client.HideImportantUI);
local LocalPlayer = Players.LocalPlayer;
local u1 = false;

local function resolveMarker() -- Line: 38
    -- upvalues: Workspace (copy)
    local __OBJECTS = Workspace:FindFirstChild("__OBJECTS");

    if __OBJECTS then
        __OBJECTS = __OBJECTS:FindFirstChild("Areas");
    end;

    if __OBJECTS then
        __OBJECTS = __OBJECTS:FindFirstChild("AdminAbuseEggSpawn");
    end;

    if __OBJECTS == nil or not __OBJECTS:IsA("BasePart") then
        return nil;
    end;

    return __OBJECTS;
end;

local function restoreCamera() -- Line: 49
    -- upvalues: Workspace (copy), LocalPlayer (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera == nil then
        return;
    end;

    CurrentCamera.CameraType = Enum.CameraType.Custom;
    CurrentCamera.FieldOfView = 70;
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    if Character ~= nil then
        CurrentCamera.CameraSubject = Character;
    end;
end;

local function stopCutscene() -- Line: 65
    -- upvalues: u1 (ref), Workspace (copy), LocalPlayer (copy), HideImportantUI (copy)
    if not u1 then
        return;
    end;

    u1 = false;
    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera ~= nil then
        CurrentCamera.CameraType = Enum.CameraType.Custom;
        CurrentCamera.FieldOfView = 70;
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        if Character ~= nil then
            CurrentCamera.CameraSubject = Character;
        end;
    end;

    HideImportantUI:UnHide();
end;

local function resolveEggShot(p2) -- Line: 75
    local v3 = p2:GetAttribute("Facing");
    local v4 = p2:GetAttribute("Finish");

    if typeof(v3) ~= "Vector3" or typeof(v4) ~= "Vector3" then
        return nil;
    end;

    local v5 = Vector3.new(v3.X, 0, v3.Z);

    if v5.Magnitude <= 0 then
        return nil;
    end;

    local v6, v7 = p2:GetBoundingBox();
    local v8 = v4 + (v6.Position - p2:GetPivot().Position);

    return CFrame.lookAt(v8 + (v5.Unit * 0.9945218953682733 + Vector3.new(0, 0.104528464, 0)) * (v7.Y / 0.8 * 0.5 / 0.22169466264293988), v8);
end;

local function startCutscene() -- Line: 98
    -- upvalues: u1 (ref), HideImportantUI (copy), Workspace (copy), TweenService (copy), RunService (copy), resolveEggShot (copy)
    if u1 then
        return;
    end;

    HideImportantUI:Hide();
    local __OBJECTS = Workspace:FindFirstChild("__OBJECTS");

    if __OBJECTS then
        __OBJECTS = __OBJECTS:FindFirstChild("Areas");
    end;

    if __OBJECTS then
        __OBJECTS = __OBJECTS:FindFirstChild("AdminAbuseEggSpawn");
    end;

    if __OBJECTS == nil or not __OBJECTS:IsA("BasePart") then
        __OBJECTS = nil;
    end;

    local CurrentCamera = Workspace.CurrentCamera;

    if __OBJECTS == nil or CurrentCamera == nil then
        return;
    end;

    u1 = true;
    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    TweenService:Create(CurrentCamera, TweenInfo.new(2), {
        FieldOfView = 80
    }):Play();
    local u9 = CFrame.lookAt(__OBJECTS.Position + Vector3.new(-200, 25, 0), __OBJECTS.Position + Vector3.new(0, 165, 0));
    CurrentCamera.CFrame = u9;
    task.spawn(function() -- Line: 122
        -- upvalues: u1 (ref), RunService (ref), CurrentCamera (copy), Workspace (ref), u9 (copy), resolveEggShot (ref)
        while u1 do
            local v10 = RunService.RenderStepped:Wait();

            if not u1 then
                break;
            end;

            CurrentCamera.CameraType = Enum.CameraType.Scriptable;
            local AdminAbuseEggDrop = Workspace:FindFirstChild("AdminAbuseEggDrop");

            if AdminAbuseEggDrop == nil or not AdminAbuseEggDrop:IsA("Model") then
                CurrentCamera.CFrame = u9;
            else
                local v11 = resolveEggShot(AdminAbuseEggDrop);

                if v11 == nil then
                    CurrentCamera.CFrame = u9;
                elseif AdminAbuseEggDrop:GetAttribute("Done") then
                    local v12 = math.clamp(v10 * 2.5, 0, 1);
                    CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(v11, v12);
                    local v13 = CurrentCamera;
                    v13.FieldOfView = v13.FieldOfView + (25 - CurrentCamera.FieldOfView) * v12;
                else
                    local Position = AdminAbuseEggDrop:GetPivot().Position;
                    local v14 = AdminAbuseEggDrop:GetAttribute("Start");
                    local v15 = AdminAbuseEggDrop:GetAttribute("Finish");
                    local v16 = v14.Y - v15.Y;
                    local v17 = v16 <= 0 and 1 or 1 - (Position.Y - v15.Y) / v16;
                    CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(CFrame.lookAt(v11.Position, Position), (math.clamp(v10 * 2, 0, 1)));
                    local v18 = math.clamp(v17, 0, 1);
                    CurrentCamera.FieldOfView = math.lerp(80, 25, v18);
                end;
            end;
        end;
    end);
end;

local function onPhaseChanged() -- Line: 166
    -- upvalues: Workspace (copy), startCutscene (copy), u1 (ref), LocalPlayer (copy), HideImportantUI (copy)
    if Workspace:GetAttribute("AdminAbusePhase") == "Cutscene" then
        startCutscene();

        return;
    end;

    if not u1 then
        return;
    end;

    u1 = false;
    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera ~= nil then
        CurrentCamera.CameraType = Enum.CameraType.Custom;
        CurrentCamera.FieldOfView = 70;
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        if Character ~= nil then
            CurrentCamera.CameraSubject = Character;
        end;
    end;

    HideImportantUI:UnHide();
end;

local v23 = {
    StartEvent = function(p19, p20, p21) -- Line: 178, Name: StartEvent
    end,

    StopEvent = function(p22) -- Line: 180, Name: StopEvent
        -- upvalues: HideImportantUI (copy), u1 (ref), Workspace (copy), LocalPlayer (copy)
        HideImportantUI:UnHide();

        if not u1 then
            return;
        end;

        u1 = false;
        local CurrentCamera = Workspace.CurrentCamera;

        if CurrentCamera ~= nil then
            CurrentCamera.CameraType = Enum.CameraType.Custom;
            CurrentCamera.FieldOfView = 70;
            local Character = LocalPlayer.Character;

            if Character then
                Character = Character:FindFirstChildOfClass("Humanoid");
            end;

            if Character ~= nil then
                CurrentCamera.CameraSubject = Character;
            end;
        end;

        HideImportantUI:UnHide();
    end
};
Workspace:GetAttributeChangedSignal("AdminAbusePhase"):Connect(onPhaseChanged);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 186
    -- upvalues: u1 (ref), Workspace (copy), LocalPlayer (copy)
    if not u1 then
        local CurrentCamera = Workspace.CurrentCamera;

        if CurrentCamera == nil then
            return;
        end;

        CurrentCamera.CameraType = Enum.CameraType.Custom;
        CurrentCamera.FieldOfView = 70;
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        if Character ~= nil then
            CurrentCamera.CameraSubject = Character;
        end;
    end;
end);

if Workspace:GetAttribute("AdminAbusePhase") == "Cutscene" then
    startCutscene();
elseif u1 then
    u1 = false;
    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera ~= nil then
        CurrentCamera.CameraType = Enum.CameraType.Custom;
        CurrentCamera.FieldOfView = 70;
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        if Character ~= nil then
            CurrentCamera.CameraSubject = Character;
        end;
    end;

    HideImportantUI:UnHide();
end;

return v23;