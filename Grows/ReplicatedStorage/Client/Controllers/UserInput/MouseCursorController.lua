-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local Knit = require(ReplicatedStorage.Packages.Knit);
require(ReplicatedStorage.Packages.Signal);
require(ReplicatedStorage.Client.Controllers.UI_Manager);
require(ReplicatedStorage.Shared.Info.Images);
local CustomEnum = require(ReplicatedStorage.Shared.Info.CustomEnum);
local Player = Knit.Player;
local PlayerGui = Player.PlayerGui;
local MouseUnlock = PlayerGui:WaitForChild("HUD"):WaitForChild("MouseUnlock");
local u1 = CFrame.new(1.7, 0, 0);
CFrame.new(-1.7, 0, 0);
local u2 = false;
local u3 = nil;
local v4 = Knit.CreateController({
    Name = "MouseCursorController"
});

local function GetUpdatedCameraCFrame(p5, p6) -- Line: 31
    return CFrame.new(p5.Position, (Vector3.new(p6.CFrame.LookVector.X * 900000, p5.Position.Y, p6.CFrame.LookVector.Z * 900000)));
end;

function v4.activateShiftLock(p7) -- Line: 38
    -- upvalues: u2 (ref), u3 (ref), RunService (copy), Player (copy), u1 (copy), UserInputService (copy)
    if u2 then
        return;
    end;

    if p7.MouseMods.jobShop then
        return;
    end;

    u2 = true;

    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;

    local CurrentCamera = workspace.CurrentCamera;
    u3 = RunService.RenderStepped:Connect(function() -- Line: 54
        -- upvalues: Player (ref), CurrentCamera (copy), u1 (ref)
        local Character = Player.Character;

        if not Character then
            return;
        end;

        local Humanoid = Character:FindFirstChild("Humanoid");

        if not Humanoid then
            return;
        end;

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart then
            return;
        end;

        Humanoid.AutoRotate = false;
        local v8 = math.max((CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude - 0.5, 0);
        local v9;

        if v8 > 4 then
            v9 = u1;
        else
            v9 = CFrame.new():Lerp(u1, v8 / 4);
        end;

        local v10 = CurrentCamera;
        HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, (Vector3.new(v10.CFrame.LookVector.X * 900000, HumanoidRootPart.Position.Y, v10.CFrame.LookVector.Z * 900000)));
        CurrentCamera.CFrame = CurrentCamera.CFrame * v9;
    end);
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
    p7:updateMouseLock();
end;

function v4.disableShiftLock(p11) -- Line: 88
    -- upvalues: u2 (ref), u3 (ref), Player (copy), UserInputService (copy)
    if not u2 then
        return;
    end;

    u2 = false;

    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;

    local Character = Player.Character;

    if not Character then
        return;
    end;

    local Humanoid = Character:FindFirstChild("Humanoid");

    if not Humanoid then
        return;
    end;

    Humanoid.AutoRotate = true;

    if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
    end;

    p11:updateMouseLock();
end;

function v4.forceShiftLock(p12, p13) -- Line: 116
    if p13 then
        p12:activateShiftLock();

        return;
    end;

    p12:disableShiftLock();
end;

function v4.getShiftLockEnabled(p14) -- Line: 124
    -- upvalues: u2 (ref)
    return u2;
end;

function v4.updateMouseLock(p15) -- Line: 128
    -- upvalues: u2 (ref), CustomEnum (copy), MouseUnlock (copy), UserInputService (copy), PlayerGui (copy)
    local v16 = false;
    local v17 = false;
    local v18 = false;
    local v19 = true;

    if not (p15.MouseMods.windowOpen or p15.MouseMods.SkillSelect) then
        v17 = p15.MouseMods.rangedMouseHide and true or v17;
        v18 = p15.MouseMods.reticleGui and true or v18;
        v16 = (p15.MouseMods.firstPerson or u2) and true or v16;

        if p15.MouseMods.hotbarSelect then
            v16 = false;
            v18 = false;
            v19 = false;
            v17 = false;
        end;
    end;

    if p15.MouseMods.jobShop then
        v16 = false;
        v18 = false;
        v19 = true;
        v17 = false;
    end;

    if p15.UserInputParser:getInputType() ~= CustomEnum.INPUT_TYPES.MOBILE then
        if v16 then
            MouseUnlock.Visible = false;
        else
            MouseUnlock.Visible = true;

            if v19 then
                p15:disableShiftLock();
            end;
        end;

        if v17 then
            UserInputService.MouseIconEnabled = false;
        else
            UserInputService.MouseIconEnabled = true;
        end;
    end;

    local ReticleGui = PlayerGui:FindFirstChild("ReticleGui");

    if ReticleGui then
        ReticleGui.Enabled = v18;
    end;
end;

function v4.AddMod(p20, p21) -- Line: 190
    if not p20.MouseMods[p21] then
        p20.MouseMods[p21] = true;
        p20:updateMouseLock();
    end;
end;

function v4.RemoveMod(p22, p23) -- Line: 197
    if p22.MouseMods[p23] then
        p22.MouseMods[p23] = nil;
        p22:updateMouseLock();
    end;
end;

function v4.KnitStart(u24) -- Line: 204
    -- upvalues: Player (copy)
    u24.MouseMods = {};

    local function updateWindowOpen() -- Line: 209
        -- upvalues: u24 (copy)
        if u24.UI_Manager:IsOpen() then
            u24:AddMod("windowOpen");

            return;
        end;

        u24:RemoveMod("windowOpen");
    end;

    u24.UI_Manager.WindowOpened:Connect(updateWindowOpen);
    u24.UI_Manager.WindowClosed:Connect(updateWindowOpen);
    local u25 = nil;

    local function setupChar() -- Line: 223
        -- upvalues: Player (ref), u25 (ref), u24 (copy)
        local Character = Player.Character;

        if not Character then
            return;
        end;

        local Head = Character:WaitForChild("Head", 10);

        if not Head then
            return;
        end;

        if u25 then
            u25:Disconnect();
        end;

        u25 = Head:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function() -- Line: 231
            -- upvalues: Head (copy), u24 (ref)
            if Head.LocalTransparencyModifier == 1 then
                u24:AddMod("firstPerson");

                return;
            end;

            u24:RemoveMod("firstPerson");
        end);
    end;

    setupChar();
    Player.CharacterAdded:Connect(setupChar);
end;

function v4.KnitInit(p26) -- Line: 249
    -- upvalues: Knit (copy)
    p26.UI_Manager = Knit.GetController("UI_Manager");
    p26.MouseCursorService = Knit.GetService("MouseCursorService");
    p26.DataClient = Knit.GetController("DataClient");
    p26.UserInputParser = Knit.GetController("UserInputParser");
end;

return v4;