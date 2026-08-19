-- Decompiled with Potassium's decompiler.

local GreenbeanHumanoidDescription = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("GreenbeanHumanoidDescription");
local u1 = {};
local u2 = {
    ["Green Bean"] = true,
    ["Maple Green Bean"] = true
};

function u1.SeedRequiresGreenbean(p3) -- Line: 21
    -- upvalues: u2 (copy)
    return u2[p3] == true;
end;

function u1.IsGreenbeanDescription(p4) -- Line: 26
    -- upvalues: GreenbeanHumanoidDescription (copy)
    if not p4 then
        return false;
    end;

    local v5 = string.split(p4.HatAccessory, ",");

    for _, v in string.split(GreenbeanHumanoidDescription.HatAccessory, ",") do
        if not table.find(v5, v) then
            return false;
        end;
    end;

    return p4.LeftArmColor == GreenbeanHumanoidDescription.LeftArmColor and (p4.LeftLegColor == GreenbeanHumanoidDescription.LeftLegColor and (p4.RightArmColor == GreenbeanHumanoidDescription.RightArmColor and (p4.RightLegColor == GreenbeanHumanoidDescription.RightLegColor and p4.TorsoColor == GreenbeanHumanoidDescription.TorsoColor)));
end;

function u1.IsCharacterGreenbean(p6) -- Line: 52
    -- upvalues: u1 (copy)
    if not p6 then
        return false;
    end;

    if p6:GetAttribute("AppliedGreenbean") then
        return true;
    end;

    local v7 = p6:FindFirstChildOfClass("Humanoid");

    if v7 then
        return u1.IsGreenbeanDescription(v7:GetAppliedDescription());
    end;

    return false;
end;

return u1;