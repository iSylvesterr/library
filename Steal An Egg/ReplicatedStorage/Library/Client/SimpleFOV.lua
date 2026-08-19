-- Decompiled with Potassium's decompiler.

local v1 = {};
local TweenService = game:GetService("TweenService");
local LocalPlayer = game.Players.LocalPlayer;
LocalPlayer:SetAttribute("Core_FOV", 70);

function v1.Change_FOV_CORE(p2) -- Line: 6
    -- upvalues: LocalPlayer (copy)
    if LocalPlayer and p2 then
        LocalPlayer:SetAttribute("Core_FOV", p2);
    end;
end;

function v1.Return_Core_FOV() -- Line: 12
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("Core_FOV");
end;

function v1.Change_FOV(p3, p4) -- Line: 16
    -- upvalues: LocalPlayer (copy), TweenService (copy)
    if game.Workspace.CurrentCamera then
        if p3 == 70 then
            p3 = LocalPlayer:GetAttribute("Core_FOV");
        end;

        local v5 = (p4 or 0.5) * (math.random(95, 105) * 0.01);
        local v6 = TweenInfo.new(v5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0);
        local v7 = TweenService:Create(game.Workspace.CurrentCamera, v6, {
            FieldOfView = p3
        });
        v7:Play();
        game.Debris:AddItem(v7, v6.Time);
    end;
end;

return v1;