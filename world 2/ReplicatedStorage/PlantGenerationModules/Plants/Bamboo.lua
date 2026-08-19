-- Decompiled with Potassium's decompiler.

local function isLocalPlayersPlant(p1) -- Line: 2
    local LocalPlayer = game.Players.LocalPlayer;

    if LocalPlayer then
        return p1:GetAttribute("UserId") == LocalPlayer.UserId;
    end;

    return false;
end;

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25,
        BaseWeight = 4
    },

    InitPlant = function(p2, p3, p4) -- Line: 13, Name: InitPlant
        local v5 = Random.new(p3);
        local Base = p2.Base;
        local v6 = p4 or 1;
        local Stud_Part = script.Stud_Part;
        local v7 = v5:NextInteger(7, 11) + v6 ^ 2;
        local v8 = math.round(v7);
        local v9 = math.round(v6 * 0.5 + 0.5);
        local v10 = v6 > 3 and v5:NextInteger(1, 3) == 1 and 2 or v9;
        local Size = Base.Size;
        local v11 = Base.CFrame * CFrame.new(0, -Base.Size.Y / 2, 0);
        local v12 = Color3.new(0, 0.666667, 0);
        local v13 = Color3.new(0, 0.392157, 0);
        local v14 = 0;
        local v15 = true;
        local v16 = 0;

        for _ = 1, v8 do
            v14 = v14 + 1;
            local v17;

            if v15 == true then
                v17 = Stud_Part:Clone();
                v17.Size = Vector3.new(v10, 3, v10);
                v17.CFrame = v11 * CFrame.new(0, v17.Size.Y / 2 + Size.Y / 2, 0);
                v17.Name = tostring(v14);
                v17.Color = v12;
                v17:SetAttribute("NoCanCollide", true);
                v17.Parent = p2;
            else
                v17 = Stud_Part:Clone();
                v17.Size = Vector3.new(v10 + 0.25, 0.5, v10 + 0.25);
                v17.CFrame = v11 * CFrame.new(0, v17.Size.Y / 2 + Size.Y / 2, 0);
                v17.Name = tostring(v14);
                v17.Color = v13;
                v17:SetAttribute("NoCanCollide", true);
                v17.Parent = p2;
            end;

            v16 = v16 + v17.Size.Y;
            v11 = v17.CFrame;
            Size = v17.Size;
            v15 = not v15;
        end;

        local v18 = v16;
        local v19 = 0;

        while v16 > 0 do
            v19 = v19 + 1;
            v16 = v16 - 1;
            local v20 = Stud_Part:Clone();
            v20.Size = Vector3.new(0.5, v10 + 0.5, v10 + 0.5);
            v20.Shape = Enum.PartType.Cylinder;
            local v21 = v19 * 1 - 0.75;
            v20.CFrame = Base.CFrame * CFrame.new(0, v21, 0);
            v20.CFrame = v20.CFrame * CFrame.Angles(0, 0, 1.5707963267948966);
            v20.Name = tostring(v14 * (v21 / v18));
            v20.Transparency = 1;
            v20:SetAttribute("OG_Transparency", 1);
            v20:SetAttribute("ClimbRung", true);
            v20.Parent = p2;
        end;

        local v22 = Stud_Part:Clone();
        v22.Name = "CollisionBlock";
        v22.Size = Vector3.new(v10 + 0.25, v18, v10 + 0.25);
        v22.CFrame = Base.CFrame * CFrame.new(0, v18 / 2, 0);
        v22.Transparency = 1;
        v22:SetAttribute("OG_Transparency", 1);
        v22:SetAttribute("IsCollisionBlock", true);
        v22:SetAttribute("MaxHeight", v18);
        v22.Parent = p2;
        p2:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u23) -- Line: 97, Name: BeginPlantGrowth
        local LocalPlayer = game.Players.LocalPlayer;
        local u24;

        if LocalPlayer then
            u24 = u23:GetAttribute("UserId") == LocalPlayer.UserId;
        else
            u24 = false;
        end;

        local PrimaryPart = u23.PrimaryPart;
        local CollisionBlock = u23:WaitForChild("CollisionBlock");
        local u25 = CollisionBlock:GetAttribute("MaxHeight");
        CollisionBlock.CanCollide = false;
        CollisionBlock.Transparency = 1;
        local u26 = {};

        for _, v in u23:QueryDescendants("BasePart") do
            local v27 = tonumber(v.Name);

            if v27 then
                local v28 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v27
                };
                table.insert(u26, v28);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 121
            -- upvalues: u23 (copy), u26 (copy), PrimaryPart (copy), u24 (copy), u25 (copy), CollisionBlock (copy)
            local v29 = u23:GetAttribute("Age") or 0;
            local v30 = u23:GetAttribute("MaxAge") or 1;
            local v31 = v29 / v30;

            for _, v in u26 do
                local v32 = v[1];
                local v33 = v[2];
                local v34 = v[3];
                local v35 = math.min((v31 - v[4] / v30) * v30, 1);
                local v36 = math.clamp(v35, 0, 1);

                if v36 ~= v.lastProgress then
                    v.lastProgress = v36;

                    if v35 > 0 then
                        v32.Size = Vector3.new(v33.X, v33.Y * v35, v33.Z);
                        v32.CFrame = PrimaryPart.CFrame * v34 * CFrame.new(0, (v32.Size.Y - v33.Y) / 2, 0);
                        v32.Transparency = v32:GetAttribute("OG_Transparency") or 0;

                        if v32:GetAttribute("ClimbRung") then
                            v32.CanCollide = u24;
                        end;

                        if v32:FindFirstChild("Decal") and v35 >= 1 then
                            for _, v2 in v32:QueryDescendants("> Decal") do
                                v2.Transparency = 0.4;
                            end;
                        end;
                    else
                        v32.Transparency = 1;
                        v32.CanCollide = false;
                    end;
                end;
            end;

            local v37 = u25 * v31;

            if v37 <= 0 then
                CollisionBlock.CanCollide = false;

                return;
            end;

            CollisionBlock.Size = Vector3.new(CollisionBlock.Size.X, v37, CollisionBlock.Size.Z);
            CollisionBlock.CFrame = PrimaryPart.CFrame * CFrame.new(0, v37 / 2, 0);
            CollisionBlock.CanCollide = not u24;
        end;

        u23:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end
};