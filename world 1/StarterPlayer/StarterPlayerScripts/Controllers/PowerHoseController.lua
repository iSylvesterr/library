-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local LocalPlayer = Players.LocalPlayer;

function v1.Init(p2) -- Line: 9
end;

function v1.Start(u3) -- Line: 12
    -- upvalues: LocalPlayer (copy), Networking (copy)
    local Character = LocalPlayer.Character;

    if Character then
        u3:SetupCharacter(Character);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p4) -- Line: 17
        -- upvalues: u3 (copy)
        u3:SetupCharacter(p4);
    end);
    Networking.PowerHose.KnockbackFx.OnClientEvent:Connect(function(p5) -- Line: 21
        -- upvalues: u3 (copy)
        u3:PlayKnockbackFx(p5);
    end);
end;

function v1.SetupCharacter(u6, p7) -- Line: 26
    local u8 = {};

    local function tryConnect(u9) -- Line: 29
        -- upvalues: u8 (copy), u6 (copy)
        if u9:IsA("Tool") and (u9:GetAttribute("PowerHose") and not u8[u9]) then
            u8[u9] = true;
            u9.Activated:Connect(function() -- Line: 32
                -- upvalues: u6 (ref), u9 (copy)
                u6:OnToolActivated(u9);
            end);
        end;
    end;

    p7.ChildAdded:Connect(tryConnect);

    for _, child in p7:GetChildren() do
        tryConnect(child);
    end;
end;

function v1.OnToolActivated(p10, p11) -- Line: 44
    -- upvalues: LocalPlayer (copy), Networking (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    if p11.Parent ~= Character then
        return;
    end;

    local v12 = p11:GetAttribute("CooldownEnd");

    if v12 and os.clock() < v12 then
        return;
    end;

    Networking.PowerHose.Activate:Fire(p11);
    local v13 = p11:GetAttribute("Cooldown") or 10;
    p11:SetAttribute("CooldownEnd", os.clock() + v13);
end;

function v1.PlayKnockbackFx(p14, p15) -- Line: 58
end;

return v1;