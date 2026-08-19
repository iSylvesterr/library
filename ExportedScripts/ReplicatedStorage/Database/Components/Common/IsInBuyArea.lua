-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);

local function IsInZone(p1, p2) -- Line: 11
    local Size = p2.Size;
    local v3 = p2.CFrame:PointToObjectSpace(p1);
    local v4;

    if math.abs(v3.X) <= Size.X / 2 and math.abs(v3.Y) <= Size.Y / 2 then
        v4 = math.abs(v3.Z) <= Size.Z / 2;
    else
        v4 = false;
    end;

    return v4;
end;

return function(p5) -- Line: 28
    -- upvalues: CollectionService (copy)
    local v6 = p5:GetAttribute("Team");
    local Character = p5.Character;

    if Character and Character:IsDescendantOf(workspace) then
        local v7 = CollectionService:GetTagged("BuyArea");

        for _, v in ipairs(v7) do
            local PrimaryPart = Character.PrimaryPart;

            if not PrimaryPart then
                return false;
            end;

            if v:GetAttribute("Team") == v6 and v:IsDescendantOf(workspace) then
                local Size = v.Size;
                local v8 = v.CFrame:PointToObjectSpace(PrimaryPart.Position);
                local v9;

                if math.abs(v8.X) <= Size.X / 2 and math.abs(v8.Y) <= Size.Y / 2 then
                    v9 = math.abs(v8.Z) <= Size.Z / 2;
                else
                    v9 = false;
                end;

                if v9 then
                    return true;
                end;
            end;
        end;
    end;

    return workspace:GetAttribute("Gamemode") == "Deathmatch";
end;