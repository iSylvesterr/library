-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = workspace.CurrentCamera;
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local u2 = {
    Top = 90,
    Bottom = 270,
    Left = 0,
    Right = 180
};
local u3 = nil;
local u4 = {
    Bottom = nil,
    Right = nil,
    Left = nil,
    Top = nil
};

local function GetQuadrantRotation(p5) -- Line: 59
    -- upvalues: u2 (copy)
    return u2[p5];
end;

local function GetRelativeRotation(p6, p7, p8) -- Line: 65
    return math.atan2(p8.Z - p6.Z, p8.X - p6.X) - math.atan2(p7.Z - p6.Z, p7.X - p6.X);
end;

local function GetQuadrantPosition(p9, p10) -- Line: 73
    local v11 = p10 / 3;

    return ({
        Top = UDim2.new(0.5, 0, 0, v11),
        Bottom = UDim2.new(0.5, 0, 1, -v11),
        Left = UDim2.new(0, v11, 0.5, 0),
        Right = UDim2.new(1, -v11, 0.5, 0)
    })[p9];
end;

local function NormalizeAngle(p12) -- Line: 86
    local v13 = math.deg(p12) % 360;

    if v13 > 180 then
        return v13 - 360;
    end;

    if v13 < -180 then
        v13 = v13 + 360;
    end;

    return v13;
end;

local function GetQuadrant(p14, p15, p16) -- Line: 101
    local v17 = p14 + p15;
    local v18 = math.atan2(p16.Z - p14.Z, p16.X - p14.X) - math.atan2(v17.Z - p14.Z, v17.X - p14.X);
    local v19 = math.deg(v18) % 360;

    if v19 > 180 then
        v19 = v19 - 360;
    elseif v19 < -180 then
        v19 = v19 + 360;
    end;

    return v19 >= -45 and v19 < 45 and "Top" or (v19 >= 45 and v19 < 135 and "Right" or ((v19 >= 135 or v19 < -135) and "Bottom" or "Left"));
end;

function u1.construct(u20) -- Line: 122
    -- upvalues: GetQuadrantPosition (copy), u2 (copy)
    local CameraPosition = u20.CameraPosition;
    local Position = u20.Position;
    local v21 = CameraPosition + u20.CameraLookVector;
    local v22 = math.atan2(Position.Z - CameraPosition.Z, Position.X - CameraPosition.X) - math.atan2(v21.Z - CameraPosition.Z, v21.X - CameraPosition.X);
    local v23 = math.deg(v22) % 360;

    if v23 > 180 then
        v23 = v23 - 360;
    elseif v23 < -180 then
        v23 = v23 + 360;
    end;

    local v24 = v23 >= -45 and v23 < 45 and "Top" or (v23 >= 45 and v23 < 135 and "Right" or ((v23 >= 135 or v23 < -135) and "Bottom" or "Left"));
    u20.Template.Position = GetQuadrantPosition(v24, u20.ScreenSize);
    u20.Template.Rotation = u2[v24];
    u20.Quadrant = v24;
    local u25 = task.delay(2, function() -- Line: 128
        -- upvalues: u20 (copy)
        u20:cleanup();
    end);
    u20.Janitor:Add(function() -- Line: 132
        -- upvalues: u25 (copy)
        if not u25 then
            return;
        end;

        pcall(task.cancel, u25);
    end);
    u20.CleanupThread = u25;
end;

function u1.cleanup(p26) -- Line: 144
    -- upvalues: LocalPlayer (copy), TweenService (copy)
    if not (p26.Template and p26.Template:IsDescendantOf(LocalPlayer.PlayerGui)) then
        return;
    end;

    p26.Janitor:Add(TweenService:Create(p26.Template, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
        ImageTransparency = 1
    })):Play();
    task.wait(0.5);
    p26:destroy();
end;

function u1.refresh(u27) -- Line: 162
    -- upvalues: TweenService (copy)
    if u27.CleanupThread then
        pcall(task.cancel, u27.CleanupThread);
        u27.CleanupThread = nil;
    end;

    if u27.FadeTween then
        u27.FadeTween:Cancel();
        u27.FadeTween = nil;
    end;

    if u27.SizeTween then
        u27.SizeTween:Cancel();
        u27.SizeTween = nil;
    end;

    local v28 = math.max(0, u27.Template.ImageTransparency - 0.1);
    u27.Template.ImageTransparency = v28;
    local u29 = task.delay(2, function() -- Line: 182
        -- upvalues: u27 (copy)
        u27:cleanup();
    end);
    u27.Janitor:Add(function() -- Line: 187
        -- upvalues: u29 (copy)
        if not u29 then
            return;
        end;

        pcall(task.cancel, u29);
    end);
    u27.CleanupThread = u29;
    local v30 = u27.Janitor:Add(TweenService:Create(u27.Template, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(u27.ScreenSize / 3, u27.ScreenSize / 3),
        ImageTransparency = v28
    }));
    v30:Play();
    u27.SizeTween = v30;
end;

function u1.new(p31, p32, p33, p34, p35) -- Line: 210
    -- upvalues: u1 (copy), Janitor (copy), ReplicatedStorage (copy), u3 (ref), Remotes (copy), TweenService (copy), u4 (copy)
    local u36 = setmetatable({}, u1);
    u36.Janitor = Janitor.new();
    u36.Template = u36.Janitor:Add(ReplicatedStorage.Assets.UI.DamageIndicator.Template:Clone());
    u36.Template.Parent = u3;
    u36.Template.ImageTransparency = 1;
    u36.Template.Name = "Indicator";
    u36.Character = p31;
    u36.ScreenSize = u3.AbsoluteSize.X;
    u36.Position = p32;
    u36.CameraLookVector = p33;
    u36.CameraPosition = p34;
    u36.Janitor:Add(Remotes.Character.CharacterDied.Listen(function() -- Line: 234
        -- upvalues: u36 (copy)
        u36:destroy();
    end));

    if not u3.Visible then
        u3.Visible = true;
    end;

    u36:construct();
    u36.SizeTween = u36.Janitor:Add(TweenService:Create(u36.Template, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
        ImageTransparency = 0.2,
        Size = UDim2.fromOffset(u36.ScreenSize / 3, u36.ScreenSize / 3)
    }));
    u36.SizeTween:Play();
    u4[p35] = u36;

    return u36;
end;

function u1.destroy(p37) -- Line: 265
    -- upvalues: u4 (copy)
    local Quadrant = p37.Quadrant;
    p37.Janitor:Destroy();

    if not (Quadrant and u4[Quadrant]) then
        return;
    end;

    u4[Quadrant] = nil;
end;

function u1.Initialize(p38, p39) -- Line: 278
    -- upvalues: u3 (ref), Remotes (copy), LocalPlayer (copy), CurrentCamera (copy), u4 (copy), u1 (copy)
    u3 = p39;
    Remotes.UI.CreateDamageIndicator.Listen(function(p40) -- Line: 281
        -- upvalues: LocalPlayer (ref), CurrentCamera (ref), u4 (ref), u1 (ref)
        if not LocalPlayer.Character then
            return;
        end;

        local Position = CurrentCamera.CFrame.Position;
        local LookVector = CurrentCamera.CFrame.LookVector;
        local v41 = Position + LookVector;
        local v42 = math.atan2(p40.Z - Position.Z, p40.X - Position.X) - math.atan2(v41.Z - Position.Z, v41.X - Position.X);
        local v43 = math.deg(v42) % 360;

        if v43 > 180 then
            v43 = v43 - 360;
        elseif v43 < -180 then
            v43 = v43 + 360;
        end;

        local v44 = v43 >= -45 and v43 < 45 and "Top" or (v43 >= 45 and v43 < 135 and "Right" or ((v43 >= 135 or v43 < -135) and "Bottom" or "Left"));
        local v45 = u4[v44];

        if v45 then
            v45:refresh();

            return;
        end;

        u1.new(LocalPlayer.Character, p40, LookVector, Position, v44);
    end);
end;

return u1;