-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("TweenService");
local Debris = game:GetService("Debris");
game:GetService("RunService");
local ShotFired = ReplicatedStorage:WaitForChild("ClientEffectsModules"):WaitForChild("EffectAssets"):WaitForChild("ShotFired");
local Shot = script:WaitForChild("Shot");
script:WaitForChild("Impact");
local World = workspace:WaitForChild("World");
local Client = World:WaitForChild("Map"):WaitForChild("PlacedItems"):WaitForChild("Client");
local Visuals = World:WaitForChild("Visuals");

return {
    Play = function(p1) -- Line: 22, Name: Play
        -- upvalues: Client (copy), ShotFired (copy), Visuals (copy), Shot (copy), Debris (copy)
        local _ = p1.Target;
        local _ = p1.TowerPosition;
        local _ = p1.TargetPosition;
        local v2 = Client:FindFirstChild(p1.TowerID);

        if not v2 then
            return;
        end;

        local Body = v2:WaitForChild("Body");
        local LeftGun = Body:WaitForChild("LeftGun");
        local RightGun = Body:WaitForChild("RightGun");
        local LeftBarrel = LeftGun:WaitForChild("LeftBarrel");
        local RightBarrel = RightGun:WaitForChild("RightBarrel");
        local LeftBarrel2 = LeftBarrel:WaitForChild("LeftBarrel");
        local RightBarrel2 = RightBarrel:WaitForChild("RightBarrel");
        local Position = LeftBarrel2.Position;
        local Position2 = RightBarrel2.Position;
        local v3 = ShotFired:Clone();
        local v4 = ShotFired:Clone();
        v3.Position = Position2;
        v4.Position = Position;
        v3.Parent = Visuals;
        v4.Parent = Visuals;
        local v5 = Shot:Clone();
        v5.Parent = v3;
        v5:Play();
        local v6 = Shot:Clone();
        v6.Parent = v4;
        v6:Play();
        local Attachment = v3:FindFirstChild("Attachment");

        if Attachment then
            if Attachment:FindFirstChild("Woosh") then
                Attachment.Woosh:Emit(4);
            end;

            if Attachment:FindFirstChild("Heat") then
                Attachment.Heat:Emit(4);
            end;

            if Attachment:FindFirstChild("Smoke") then
                Attachment.Smoke:Emit(4);
            end;
        end;

        local Attachment2 = v4:FindFirstChild("Attachment");

        if Attachment2 then
            if Attachment2:FindFirstChild("Woosh") then
                Attachment2.Woosh:Emit(4);
            end;

            if Attachment2:FindFirstChild("Heat") then
                Attachment2.Heat:Emit(4);
            end;

            if Attachment2:FindFirstChild("Smoke") then
                Attachment2.Smoke:Emit(4);
            end;
        end;

        Debris:AddItem(v3, 1.5);
        Debris:AddItem(v4, 1.5);
    end
};