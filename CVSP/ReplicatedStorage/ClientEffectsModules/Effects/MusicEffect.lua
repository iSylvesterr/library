-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
game:GetService("RunService");
require(ReplicatedStorage.Sounds.UISoundController);
local MusicEffect = ReplicatedStorage:WaitForChild("ClientEffectsModules"):WaitForChild("EffectAssets"):WaitForChild("MusicEffect");
local World = workspace:WaitForChild("World");
local Client = World:WaitForChild("Map"):WaitForChild("PlacedItems"):WaitForChild("Client");
local Visuals = World:WaitForChild("Visuals");

return {
    Play = function(p1) -- Line: 22, Name: Play
        -- upvalues: MusicEffect (copy), Visuals (copy), Client (copy), TweenService (copy), Debris (copy)
        local v2 = MusicEffect:Clone();
        v2.Position = p1.Position;
        v2.Parent = Visuals;

        if v2:FindFirstChild("MusicNote1") then
            v2.MusicNote1:Emit(5);
        end;

        if v2:FindFirstChild("MusicNote2") then
            v2.MusicNote2:Emit(5);
        end;

        local v3 = p1.ServerModelName and Client:FindFirstChild(p1.ServerModelName);

        if v3 then
            local Highlight = Instance.new("Highlight");
            Highlight.FillTransparency = 0;
            Highlight.FillColor = Color3.new(0.933333, 0, 1);
            Highlight.OutlineTransparency = 1;
            Highlight.Parent = Visuals;
            Highlight.Adornee = v3;
            local u4 = TweenInfo.new(0.25, Enum.EasingStyle.Linear);
            TweenService:Create(Highlight, u4, {
                FillTransparency = 0.25
            }):play();
            task.delay(0.25, function() -- Line: 51
                -- upvalues: TweenService (ref), Highlight (copy), u4 (copy)
                TweenService:Create(Highlight, u4, {
                    FillTransparency = 1
                }):play();
            end);
            Debris:AddItem(Highlight, 1);
        end;

        Debris:AddItem(v2, 5);
    end
};