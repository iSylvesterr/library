-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);

return function(p1, p2, p3) -- Line: 17
    -- upvalues: Asserts (copy), Players (copy)
    Asserts.Player(p1);
    Asserts.number(p2);
    local Character = p1.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if not Character then
        return nil, Vector3.new(1, 0, 0);
    end;

    local v4 = {};

    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= p1 then
            local Character2 = v.Character;

            if Character2 then
                Character2 = Character2:FindFirstChild("HumanoidRootPart");
            end;

            if Character2 then
                local Magnitude = (Character2.Position - Character.Position).Magnitude;

                if Magnitude <= p2 then
                    table.insert(v4, {
                        player = v,
                        delta = Character2.Position - Character.Position,
                        distance = Magnitude
                    });
                end;
            end;
        end;
    end;

    table.sort(v4, function(p5, p6) -- Line: 46
        return p5.distance < p6.distance;
    end);
    local v7;

    if p3 then
        local v8 = math.floor(p3);
        v7 = math.max(0, v8);
    else
        v7 = 1;
    end;

    if v7 <= 1 then
        local v9 = v4[1];

        if v9 then
            return v9.player, v9.delta;
        end;

        return nil, Vector3.new(1, 0, 0);
    end;

    local v10 = {};

    for i = 1, math.min(v7, #v4) do
        v10[i] = v4[i];
    end;

    return v10;
end;