-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local u1 = {};
local u2 = {};

local function handleCharacterUpdate(u3, p4) -- Line: 6
    -- upvalues: u2 (copy), u1 (copy)
    for _, v in u2[u3] do
        v:Disconnect();
    end;

    for i, v in u1 do
        if v == u3 then
            u1[i] = nil;
        end;
    end;

    for _, descendant in p4:GetDescendants() do
        if descendant:IsA("BasePart") then
            u1[descendant] = u3;
        end;
    end;

    table.insert(u2[u3], p4.DescendantAdded:Connect(function(p5) -- Line: 26
        -- upvalues: u1 (ref), u3 (copy)
        if not p5:IsA("BasePart") then
            return;
        end;

        u1[p5] = u3;
    end));
    table.insert(u2[u3], p4.DescendantRemoving:Connect(function(p6) -- Line: 36
        -- upvalues: u1 (ref)
        if not p6:IsA("BasePart") then
            return;
        end;

        u1[p6] = nil;
    end));
end;

local function onPlayerAdded(u7) -- Line: 45
    -- upvalues: u2 (copy), handleCharacterUpdate (copy)
    u2[u7] = {};
    u7.CharacterAdded:Connect(function(p8) -- Line: 48
        -- upvalues: handleCharacterUpdate (ref), u7 (copy)
        handleCharacterUpdate(u7, p8);
    end);

    if u7.Character then
        handleCharacterUpdate(u7, u7.Character);
    end;
end;

local function onPlayerRemoving(p9) -- Line: 57
    -- upvalues: u2 (copy), u1 (copy)
    for _, v in u2[p9] do
        v:Disconnect();
    end;

    u2[p9] = nil;

    for i, v in u1 do
        if v == p9 then
            u1[i] = nil;
        end;
    end;
end;

return {
    characterObjects = u1,

    start = function() -- Line: 72, Name: start
        -- upvalues: Players (copy), onPlayerAdded (copy), onPlayerRemoving (copy)
        local v10 = Players.PlayerAdded:Connect(onPlayerAdded);
        local v11 = Players.PlayerRemoving:Connect(onPlayerRemoving);

        for _, v in Players:GetPlayers() do
            onPlayerAdded(v);
        end;

        return v10, v11;
    end,

    onPlayerAdded = onPlayerAdded,
    onPlayerRemoving = onPlayerRemoving
};