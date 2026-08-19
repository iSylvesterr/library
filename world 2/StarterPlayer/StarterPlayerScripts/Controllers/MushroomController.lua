-- Decompiled with Potassium's decompiler.

local u1 = {};
local Networking = require(game.ReplicatedStorage.SharedModules.Networking);
local LocalPlayer = game.Players.LocalPlayer;
local TweenService = game:GetService("TweenService");
local u2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);

function u1.Init(p3) -- Line: 7
    -- upvalues: Networking (copy), u1 (copy), LocalPlayer (copy)
    Networking.Mushrooms.SetInvisiblity.OnClientEvent:Connect(function(p4) -- Line: 8
        -- upvalues: u1 (ref), LocalPlayer (ref)
        u1:SetInvisible(LocalPlayer.Character, p4);
    end);
    Networking.Mushrooms.PlayFX.OnClientEvent:Connect(function(p5) -- Line: 11
        -- upvalues: u1 (ref), LocalPlayer (ref)
        u1:PlayFX(LocalPlayer.Character, p5);
    end);
end;

function u1.PlayFX(p6, p7, p8) -- Line: 16
    -- upvalues: TweenService (copy), u2 (copy)
    local Highlight = Instance.new("Highlight");
    Highlight.FillColor = p8;
    Highlight.Parent = p7;
    Highlight.FillTransparency = 0;
    Highlight.OutlineTransparency = 1;
    Highlight:SetAttribute("InvisiblityHighlight", true);
    Highlight.Adornee = p7;
    local v9 = TweenService:Create(Highlight, u2, {
        FillTransparency = 1
    });
    v9:Play();
    game.Debris:AddItem(v9, u2.Time);
    game.Debris:AddItem(Highlight, u2.Time);
end;

function u1.SetInvisible(p10, p11, p12) -- Line: 31
    if p12 ~= true then
        for _, child in p11:GetChildren() do
            if child:IsA("Highlight") and child:GetAttribute("InvisiblityHighlight") then
                child:Destroy();
            end;
        end;

        return;
    end;

    local Highlight = Instance.new("Highlight");
    Highlight.Parent = p11;
    Highlight.FillTransparency = 0.5;
    Highlight.OutlineTransparency = 0.9967;
    Highlight.FillColor = Color3.new(1, 1, 1);
    Highlight:SetAttribute("InvisiblityHighlight", true);
    Highlight.Adornee = p11;
end;

return u1;