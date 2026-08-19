-- Decompiled with Potassium's decompiler.

local StarterGui = game:GetService("StarterGui");

local function apply() -- Line: 13
    -- upvalues: StarterGui (copy)
    local u1 = workspace:GetAttribute("InAdminParty") == true;

    return pcall(function() -- Line: 15
        -- upvalues: StarterGui (ref), u1 (copy)
        StarterGui:SetCore("ResetButtonCallback", u1);
    end);
end;

workspace:GetAttributeChangedSignal("InAdminParty"):Connect(function() -- Line: 22
    -- upvalues: StarterGui (copy)
    local u2 = workspace:GetAttribute("InAdminParty") == true;
    pcall(function() -- Line: 15
        -- upvalues: StarterGui (ref), u2 (copy)
        StarterGui:SetCore("ResetButtonCallback", u2);
    end);
end);

while true do
    local u3 = workspace:GetAttribute("InAdminParty") == true;

    if pcall(function() -- Line: 15
        -- upvalues: StarterGui (copy), u3 (copy)
        StarterGui:SetCore("ResetButtonCallback", u3);
    end) then
        break;
    end;

    task.wait(1);
end;