-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Particles = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Particles");
local Functions = require(Library.Functions);
local Confetti = Particles:WaitForChild("Confetti");

function EmitConfetti(p1, u2, u3)
    -- upvalues: Functions (copy), Confetti (copy)
    return Functions.Emit(p1, function(p4) -- Line: 9
        -- upvalues: u2 (copy), u3 (copy), Functions (ref)
        if u2 then
            p4:SetAttribute("EmitCount", (p4:GetAttribute("EmitCount") or 0) * u2);
        end;

        if u3 then
            Functions.Scaler()(p4, u3);
        end;
    end, Confetti:GetChildren());
end;

return EmitConfetti;