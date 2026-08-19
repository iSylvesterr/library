-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local LocalPlayer = Players.LocalPlayer;
local Gravity = game.SoundService.SFX.Gravity;
local u1 = {
    NewGravity = 20,
    Duration = 15,
    JumpHeightMult = 4,
    Applied = false,
    DefaultGravity = workspace.Gravity
};
local RadialFXController = require(script.Parent.RadialFXController);
local FieldOfViewController = require(script.Parent.FieldOfViewController);
local u2 = TweenInfo.new(7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u3 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u4 = {
    Connections = {}
};
local u5 = nil;
local u6 = 0;

local function DisconnectAll() -- Line: 35
    -- upvalues: u4 (copy)
    for i, v in u4.Connections do
        v:Disconnect();
        u4.Connections[i] = nil;
    end;
end;

local function ReconnectAll() -- Line: 43
    -- upvalues: CollectionService (copy), u4 (copy)
    for _, v in CollectionService:GetTagged("MoonBloom") do
        u4:RegisterPart(v);
    end;
end;

function u4.RegisterPart(p7, p8) -- Line: 49
    -- upvalues: u4 (copy), u1 (copy), LocalPlayer (copy), Networking (copy), RadialFXController (copy), TweenService (copy), u2 (copy), Gravity (copy), u6 (ref), FieldOfViewController (copy), u5 (ref), u3 (copy), CollectionService (copy)
    if u4.Connections[p8] then
        return;
    end;

    u4.Connections[p8] = p8.Touched:Connect(function(p9) -- Line: 53
        -- upvalues: u1 (ref), LocalPlayer (ref), Networking (ref), u4 (ref), RadialFXController (ref), TweenService (ref), u2 (ref), Gravity (ref), u6 (ref), FieldOfViewController (ref), u5 (ref), u3 (ref), CollectionService (ref)
        if u1.Applied then
            return;
        end;

        local Character = LocalPlayer.Character;

        if not Character then
            return;
        end;

        if not p9:IsDescendantOf(Character) then
            return;
        end;

        u1.Applied = true;
        Networking.MoonBloom.GravityTouched:Fire();

        for i, v in u4.Connections do
            v:Disconnect();
            u4.Connections[i] = nil;
        end;

        local JumpHeight = Character.Humanoid.JumpHeight;
        Character.Humanoid.JumpHeight = JumpHeight * u1.JumpHeightMult;
        workspace.Gravity = u1.NewGravity;
        RadialFXController:PlayFX("MoonBloom");
        local Highlight = Instance.new("Highlight");
        Highlight.Adornee = Character;
        Highlight.Parent = LocalPlayer.PlayerGui;
        Highlight.FillColor = Color3.new(0, 0.666667, 1);
        Highlight.OutlineTransparency = 1;
        Highlight.FillTransparency = 0.5;
        TweenService:Create(Highlight, u2, {
            FillTransparency = 1
        }):Play();
        game.Debris:AddItem(Highlight, u2.Time);
        Gravity.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        Gravity.TimePosition = 0;
        Gravity.Playing = true;
        u6 = FieldOfViewController:GetAdjuster();
        FieldOfViewController:SetAdjuster(u6 + 30, false);

        if u5 then
            task.cancel(u5);
        end;

        u5 = task.delay(1, function() -- Line: 98
            -- upvalues: u5 (ref), FieldOfViewController (ref), u6 (ref)
            u5 = nil;
            FieldOfViewController:SetAdjuster(u6, false);
        end);
        task.delay(u1.Duration, function() -- Line: 104
            -- upvalues: u5 (ref), FieldOfViewController (ref), u6 (ref), TweenService (ref), u3 (ref), u1 (ref), Character (copy), JumpHeight (copy), CollectionService (ref), u4 (ref)
            if u5 then
                task.cancel(u5);
                u5 = nil;
            end;

            FieldOfViewController:SetAdjuster(u6, false);
            local v10 = TweenService:Create(workspace, u3, {
                Gravity = u1.DefaultGravity
            });
            v10:Play();
            game.Debris:AddItem(v10, u3.Time);
            local v11 = TweenService:Create(Character.Humanoid, u3, {
                JumpHeight = JumpHeight
            });
            v11:Play();
            game.Debris:AddItem(v11, u3.Time);
            task.delay(u3.Time, function() -- Line: 119
                -- upvalues: u1 (ref), CollectionService (ref), u4 (ref)
                u1.Applied = false;

                for _, v in CollectionService:GetTagged("MoonBloom") do
                    u4:RegisterPart(v);
                end;
            end);
        end);
    end);
end;

function u4.UnregisterPart(p12, p13) -- Line: 128
    -- upvalues: u4 (copy)
    if u4.Connections[p13] then
        u4.Connections[p13]:Disconnect();
        u4.Connections[p13] = nil;
    end;
end;

function u4.Start(u14) -- Line: 135
    -- upvalues: CollectionService (copy), u1 (copy)
    for _, v in CollectionService:GetTagged("MoonBloom") do
        u14:RegisterPart(v);
    end;

    CollectionService:GetInstanceAddedSignal("MoonBloom"):Connect(function(p15) -- Line: 141
        -- upvalues: u1 (ref), u14 (copy)
        if not u1.Applied then
            u14:RegisterPart(p15);
        end;
    end);
    CollectionService:GetInstanceRemovedSignal("MoonBloom"):Connect(function(p16) -- Line: 148
        -- upvalues: u14 (copy)
        u14:UnregisterPart(p16);
    end);
end;

return u4;