-- Decompiled with Potassium's decompiler.

local v1 = game:GetService("Selection"):Get();
local Anim = workspace.NewBrainrot.Anim;

for _, v in ipairs(v1) do
    local v2 = string.split(v.Name, " : ");
    local v3 = v2[1];
    local v4 = v2[2];

    for _, descendant in ipairs(Anim:GetDescendants()) do
        if descendant:IsA("Animation") and descendant.AnimationId:match(v3) then
            descendant.AnimationId = "rbxassetid://" .. v4;
            warn("done");
        end;
    end;
end;