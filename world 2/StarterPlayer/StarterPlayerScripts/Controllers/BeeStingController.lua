-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local LocalPlayer = Players.LocalPlayer;
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local v1 = {};
local u2 = false;
local u3 = 0;
local u4 = 0;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = (-1 / 0);
local u10 = 0;
local u11 = 0;
local u12 = nil;

local function getControls() -- Line: 94
    -- upvalues: u12 (ref), LocalPlayer (copy)
    if u12 then
        return u12;
    end;

    local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts");

    if not PlayerScripts then
        return nil;
    end;

    local PlayerModule = PlayerScripts:FindFirstChild("PlayerModule");

    if not PlayerModule then
        return nil;
    end;

    local success, result = pcall(function() -- Line: 100
        -- upvalues: PlayerModule (copy)
        return require(PlayerModule);
    end);

    if not (success and result) then
        return nil;
    end;

    local success2, result2 = pcall(function() -- Line: 104
        -- upvalues: result (copy)
        return result:GetControls();
    end);

    if not (success2 and result2) then
        return nil;
    end;

    u12 = result2;

    return u12;
end;

local u13 = nil;
local u14 = nil;
local u15 = false;

local function getCameraInput() -- Line: 123
    -- upvalues: u13 (ref), LocalPlayer (copy)
    if u13 then
        return u13;
    end;

    local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts");

    if not PlayerScripts then
        return nil;
    end;

    local PlayerModule = PlayerScripts:FindFirstChild("PlayerModule");

    if not PlayerModule then
        return nil;
    end;

    local CameraModule = PlayerModule:FindFirstChild("CameraModule");

    if not CameraModule then
        return nil;
    end;

    local CameraInput = CameraModule:FindFirstChild("CameraInput");

    if not CameraInput then
        return nil;
    end;

    local success, result = pcall(function() -- Line: 133
        -- upvalues: CameraInput (copy)
        return require(CameraInput);
    end);

    if not (success and result) then
        return nil;
    end;

    u13 = result;

    return u13;
end;

local function buildGui() -- Line: 141
    -- upvalues: LocalPlayer (copy), Lighting (copy), u6 (ref), u7 (ref), u8 (ref)
    local v16 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if not v16 then
        return;
    end;

    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "BeeStingScreenEffect";
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.DisplayOrder = 1000;
    ScreenGui.Parent = v16;
    local Frame = Instance.new("Frame");
    Frame.Name = "RedFlash";
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundColor3 = Color3.fromRGB(255, 55, 55);
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.ZIndex = 10;
    Frame.Parent = ScreenGui;
    local BlurEffect = Instance.new("BlurEffect");
    BlurEffect.Name = "BeeStingBlur";
    BlurEffect.Size = 1;
    BlurEffect.Enabled = true;
    BlurEffect.Parent = Lighting;
    u6 = ScreenGui;
    u7 = Frame;
    u8 = BlurEffect;
end;

local function teardownGui() -- Line: 174
    -- upvalues: u6 (ref), u7 (ref), u8 (ref)
    if u6 then
        u6:Destroy();
        u6 = nil;
        u7 = nil;
    end;

    if u8 then
        u8:Destroy();
        u8 = nil;
    end;
end;

local function smoothResetCamera() -- Line: 186
    -- upvalues: LocalPlayer (copy), TweenService (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    local v17 = Character:FindFirstChildOfClass("Humanoid");

    if not v17 then
        return;
    end;

    TweenService:Create(v17, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        CameraOffset = Vector3.new(0, 0, 0)
    }):Play();
end;

local function startInversion() -- Line: 202
    -- upvalues: RunService (copy), getControls (copy), LocalPlayer (copy)
    RunService:BindToRenderStep("BeeStingInvertMovement", Enum.RenderPriority.Input.Value + 1, function() -- Line: 203
        -- upvalues: getControls (ref), LocalPlayer (ref)
        local v18 = getControls();

        if not v18 then
            return;
        end;

        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        if not Character then
            return;
        end;

        Character:Move(-v18:GetMoveVector(), true);
    end);
end;

local function stopInversion() -- Line: 216
    -- upvalues: RunService (copy)
    pcall(function() -- Line: 217
        -- upvalues: RunService (ref)
        RunService:UnbindFromRenderStep("BeeStingInvertMovement");
    end);
end;

local function startCameraInversion() -- Line: 226
    -- upvalues: u15 (ref), getCameraInput (copy), u14 (ref)
    if u15 then
        return;
    end;

    local u19 = getCameraInput();

    if not u19 then
        return;
    end;

    if typeof(u19.getRotation) ~= "function" then
        return;
    end;

    pcall(function() -- Line: 232
        -- upvalues: u14 (ref), u19 (copy)
        u14 = u19.getRotation;

        function u19.getRotation(...) -- Line: 234
            -- upvalues: u14 (ref)
            local v20 = u14(...);

            if typeof(v20) == "Vector2" then
                return -v20;
            end;

            return v20;
        end;
    end);
    u15 = true;
end;

local function stopCameraInversion() -- Line: 245
    -- upvalues: u14 (ref), u13 (ref), u15 (ref)
    if u14 and u13 then
        pcall(function() -- Line: 247
            -- upvalues: u13 (ref), u14 (ref)
            u13.getRotation = u14;
        end);
    end;

    u14 = nil;
    u15 = false;
end;

local function stop() -- Line: 255
    -- upvalues: u2 (ref), u5 (ref), RunService (copy), u14 (ref), u13 (ref), u15 (ref), smoothResetCamera (copy), u6 (ref), u7 (ref), u8 (ref)
    if not u2 then
        return;
    end;

    u2 = false;

    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;

    pcall(function() -- Line: 217
        -- upvalues: RunService (ref)
        RunService:UnbindFromRenderStep("BeeStingInvertMovement");
    end);

    if u14 and u13 then
        pcall(function() -- Line: 247
            -- upvalues: u13 (ref), u14 (ref)
            u13.getRotation = u14;
        end);
    end;

    u14 = nil;
    u15 = false;
    smoothResetCamera();

    if u6 then
        u6:Destroy();
        u6 = nil;
        u7 = nil;
    end;

    if u8 then
        u8:Destroy();
        u8 = nil;
    end;
end;

local function start() -- Line: 270
    -- upvalues: u6 (ref), u7 (ref), u8 (ref), buildGui (copy), u2 (ref), u3 (ref), RunService (copy), getControls (copy), LocalPlayer (copy), u15 (ref), getCameraInput (copy), u14 (ref), u5 (ref), u4 (ref), u13 (ref), smoothResetCamera (copy), u9 (ref), u10 (ref), u11 (ref)
    if u6 then
        u6:Destroy();
        u6 = nil;
        u7 = nil;
    end;

    if u8 then
        u8:Destroy();
        u8 = nil;
    end;

    buildGui();

    if not u7 then
        return;
    end;

    u2 = true;
    u3 = tick();
    RunService:BindToRenderStep("BeeStingInvertMovement", Enum.RenderPriority.Input.Value + 1, function() -- Line: 203
        -- upvalues: getControls (ref), LocalPlayer (ref)
        local v21 = getControls();

        if not v21 then
            return;
        end;

        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        if not Character then
            return;
        end;

        Character:Move(-v21:GetMoveVector(), true);
    end);

    if not u15 then
        local u22 = getCameraInput();

        if u22 and typeof(u22.getRotation) == "function" then
            pcall(function() -- Line: 232
                -- upvalues: u14 (ref), u22 (copy)
                u14 = u22.getRotation;

                function u22.getRotation(...) -- Line: 234
                    -- upvalues: u14 (ref)
                    local v23 = u14(...);

                    if typeof(v23) == "Vector2" then
                        return -v23;
                    end;

                    return v23;
                end;
            end);
            u15 = true;
        end;
    end;

    u5 = RunService.RenderStepped:Connect(function() -- Line: 285
        -- upvalues: u4 (ref), u2 (ref), u5 (ref), RunService (ref), u14 (ref), u13 (ref), u15 (ref), smoothResetCamera (ref), u6 (ref), u7 (ref), u8 (ref), LocalPlayer (ref), u3 (ref), u9 (ref), u10 (ref), u11 (ref)
        local v24 = tick();

        if u4 <= v24 then
            if not u2 then
                return;
            end;

            u2 = false;

            if u5 then
                u5:Disconnect();
                u5 = nil;
            end;

            pcall(function() -- Line: 217
                -- upvalues: RunService (ref)
                RunService:UnbindFromRenderStep("BeeStingInvertMovement");
            end);

            if u14 and u13 then
                pcall(function() -- Line: 247
                    -- upvalues: u13 (ref), u14 (ref)
                    u13.getRotation = u14;
                end);
            end;

            u14 = nil;
            u15 = false;
            smoothResetCamera();

            if u6 then
                u6:Destroy();
                u6 = nil;
                u7 = nil;
            end;

            if u8 then
                u8:Destroy();
                u8 = nil;
            end;

            return;
        end;

        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        if Character then
            local v25 = v24 - u3;
            local v26 = math.sin(v25 * 4) * 1.65 + math.sin(v25 * 7.3) * 0.49499999999999994;
            local v27 = math.cos(v25 * 5.2) * 1.35 + math.sin(v25 * 9.1) * 0.3375;
            local v28 = v24 - u9;

            if v28 >= 0 and v28 < 0.35 then
                local v29 = (1 - v28 / 0.35) ^ 3;
                v26 = v26 + u10 * 3 * v29;
                v27 = v27 + u11 * 3 * v29;
            end;

            Character.CameraOffset = Vector3.new(v26, v27, 0);
        end;

        local v30 = math.sin((v24 - u3) * 2.5);
        local v31 = math.max(0, v30);
        local v32 = 0.8 - v31 * 0.2;
        local v33 = v24 - u9;
        local v34 = (v33 < 0 or v33 >= 0.28) and 1 or 0.05 + 0.95 * (v33 / 0.28);

        if u7 then
            u7.BackgroundTransparency = math.min(v32, v34);
        end;

        if u8 then
            u8.Size = v31 * 4 + 1;
        end;
    end);
end;

local function onSting(p35) -- Line: 348
    -- upvalues: u9 (ref), u10 (ref), u11 (ref), u2 (ref), u4 (ref), start (copy)
    local v36 = tick();
    u9 = v36;
    local v37 = math.random() * 3.141592653589793 * 2;
    u10 = math.cos(v37);
    u11 = math.sin(v37);
    local v38 = (typeof(p35) ~= "number" or p35 <= 0) and 3.5 or p35;

    if u2 then
        u4 = v36 + v38;

        return;
    end;

    u4 = v36 + v38;
    start();
end;

function v1.Init(p39) -- Line: 379
    -- upvalues: Networking (copy), onSting (copy)
    Networking.Bee.Sting.OnClientEvent:Connect(onSting);
end;

return v1;