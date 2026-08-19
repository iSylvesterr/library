-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");

return function(p1) -- Line: 11, Name: safePlayerAdded
    -- upvalues: Players (copy)
    for _, v in Players:GetPlayers() do
        task.spawn(p1, v);
    end;

    return Players.PlayerAdded:Connect(p1);
end;