-- Decompiled with Potassium's decompiler.

({}).StartOrder = 3;
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
local FieldOfViewController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.FieldOfViewController);
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local Signal = require(ReplicatedStorage.ClientModules.Signal);
local u1 = {};
local u2 = { "TeleportButtons", "GrowingList", "PetList", "BackpackGui", "HUD", "MushroomUI", "DripUpdateNotification" };
local u3 = {};
local Blur = Lighting.Blur;
local _ = workspace.CurrentCamera;
local u4 = Signal.new();
local u5 = Signal.new();
local u6 = Signal.new();
local v7 = {
    _Locked = false,
    Gui = nil,
    GuiFocusedSignal = u5,
    GuiUnfocusedSignal = u4,
    GuiHiddenSignal = u6
};

local function SetHudGuisEnabled(p8, p9) -- Line: 84
    -- upvalues: u2 (copy), u3 (copy), PlayerGui (copy)
    for _, v in u2 do
        local v10, v11;

        if u3[v] then
            v10 = false;
            v11 = PlayerGui:FindFirstChild(v);

            if v11 and v11.Name ~= "TouchGui" then
                v11.Enabled = v10;
            end;
        elseif p8 or not (p9 and table.find(p9, v)) then
            v10 = p8;
            v11 = PlayerGui:FindFirstChild(v);

            if v11 and v11.Name ~= "TouchGui" then
                v11.Enabled = v10;
            end;
        end;
    end;
end;

function v7.Unlock(p12) -- Line: 109
    p12._Locked = false;
end;

function v7.Lock(p13) -- Line: 116
    p13._Locked = true;
end;

function v7.IsOpen(p14, p15) -- Line: 123
    -- upvalues: PlayerGui (copy)
    local v16 = PlayerGui:FindFirstChild(p15);

    if v16 then
        return p14.Gui == v16 and true or v16.Enabled;
    end;

    return false;
end;

function v7.Close(p17, p18, p19) -- Line: 142
    -- upvalues: PlayerGui (copy), u2 (copy), u3 (copy), u4 (copy), TweenService (copy), Blur (copy), FieldOfViewController (copy)
    if p19 then
        p17._Locked = false;
    elseif p17._Locked then
        return;
    end;

    local Gui = p17.Gui;
    local v20;

    if p18 then
        v20 = PlayerGui:FindFirstChild(p18);
    else
        v20 = Gui;
    end;

    if not (v20 and v20:IsA("ScreenGui")) then
        return;
    end;

    v20.Enabled = false;

    if v20 ~= Gui then
        return;
    end;

    p17.Gui = nil;

    for _, v in u2 do
        local v21 = not u3[v];
        local v22 = PlayerGui:FindFirstChild(v);

        if v22 and v22.Name ~= "TouchGui" then
            v22.Enabled = v21;
        end;
    end;

    u4:Fire(v20);
    TweenService:Create(Blur, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = 0
    }):Play();
    FieldOfViewController:SetBaseFOV(70);
end;

function v7.Open(p23, p24, p25, p26) -- Line: 173
    -- upvalues: PlayerGui (copy), SetHudGuisEnabled (copy), u5 (copy), TweenService (copy), Blur (copy), FieldOfViewController (copy)
    if p25 then
        p23._Locked = false;
    elseif p23._Locked then
        return;
    end;

    local v27 = PlayerGui:FindFirstChild(p24);

    if not v27 then
        return;
    end;

    if not v27:IsA("ScreenGui") then
        return;
    end;

    if p23.Gui then
        p23:Close(nil, p25);
    end;

    p23.Gui = v27;

    if p23.Gui then
        p23.Gui.Enabled = true;
    end;

    SetHudGuisEnabled(false, p26 or nil);
    u5:Fire(v27);
    TweenService:Create(Blur, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = 20
    }):Play();
    FieldOfViewController:SetBaseFOV(60);
end;

function v7.Hook(p28, p29, ...) -- Line: 211
    -- upvalues: u1 (copy)
    local v30 = u1[p29];

    if v30 then
        return v30.new(...);
    end;
end;

function v7.SetHUDVisibility(p31, p32) -- Line: 223
    -- upvalues: u6 (copy)
    u6:Fire(p32);
end;

function v7.SetGuiForceHidden(p33, p34, p35) -- Line: 232
    -- upvalues: u3 (copy), PlayerGui (copy)
    if p35 then
        u3[p34] = true;
    else
        u3[p34] = nil;
    end;

    local v36 = PlayerGui:FindFirstChild(p34);

    if not (v36 and v36:IsA("ScreenGui")) then
        return;
    end;

    if p35 then
        v36.Enabled = false;

        return;
    end;

    if not p33.Gui then
        v36.Enabled = true;
    end;
end;

function v7.SnapshotHudStates(p37) -- Line: 256
    -- upvalues: u2 (copy), PlayerGui (copy)
    local v38 = {};

    for _, v in u2 do
        local v39 = PlayerGui:FindFirstChild(v);

        if v39 then
            v38[v] = v39.Enabled;
        end;
    end;

    return v38;
end;

function v7.RestoreHudStates(p40, p41) -- Line: 270
    -- upvalues: u3 (copy), PlayerGui (copy)
    if not p41 then
        return;
    end;

    for i, v in p41 do
        if not u3[i] then
            local v42 = PlayerGui:FindFirstChild(i);

            if v42 and v42.Name ~= "TouchGui" then
                v42.Enabled = v;
            end;
        end;
    end;
end;

function v7.Init(p43) -- Line: 285
end;

function v7.Start(p44) -- Line: 289
    -- upvalues: u1 (copy)
    for _, child in script:WaitForChild("Components"):GetChildren() do
        if child:IsA("ModuleScript") then
            local success, _ = pcall(function() -- Line: 295
                -- upvalues: child (copy)
                return require(child);
            end);

            if success then
                u1[child.Name] = require(child);
            end;
        end;
    end;
end;

return v7;