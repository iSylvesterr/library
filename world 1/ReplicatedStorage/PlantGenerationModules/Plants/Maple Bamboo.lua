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
        local v12 = Color3.new(0.666667, 0.380392, 0.133333);
        local v13 = Color3.new(0.886275, 0.6, 0.027451);
        Color3.new(1, 0.682353, 0.298039);
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
                v17.Material = Enum.Material.Glacier;
                v17.MaterialVariant = "2022 Stud Bark";
                v17:SetAttribute("NoCanCollide", true);

                for _, child in script.fade:GetChildren() do
                    child:Clone().Parent = v17;
                end;

                v17.Parent = p2;
            else
                v17 = Stud_Part:Clone();
                v17.Size = Vector3.new(v10 + 0.25, 0.5, v10 + 0.25);
                v17.CFrame = v11 * CFrame.new(0, v17.Size.Y / 2 + Size.Y / 2, 0);
                v17.Name = tostring(v14);
                v17.Color = v13;
                v17.Material = Enum.Material.Glacier;
                v17.MaterialVariant = "2022 Stud Bark";
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

    BeginPlantGrowth = function(u23) -- Line: 107, Name: BeginPlantGrowth
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
                local v28 = not v:GetAttribute("DontShow");
                local v29 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v29, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v28 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v30 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v27,
                    decals = v29
                };
                table.insert(u26, v30);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 150
            -- upvalues: u23 (copy), u26 (copy), PrimaryPart (copy), u24 (copy), u25 (copy), CollisionBlock (copy)
            local v31 = u23:GetAttribute("Age") or 0;
            local v32 = u23:GetAttribute("MaxAge") or 1;
            local v33 = v31 / v32;

            for _, v in u26 do
                local v34 = v[1];
                local v35 = v[2];
                local v36 = v[3];
                local v37 = math.min((v33 - v[4] / v32) * v32, 1);
                local v38 = math.clamp(v37, 0, 1);

                if v38 ~= v.lastProgress then
                    v.lastProgress = v38;

                    if v37 > 0 then
                        v34.Size = Vector3.new(v35.X, v35.Y * v37, v35.Z);
                        v34.CFrame = PrimaryPart.CFrame * v36 * CFrame.new(0, (v34.Size.Y - v35.Y) / 2, 0);
                        v34.Transparency = v34:GetAttribute("OG_Transparency") or 0;

                        if v34:GetAttribute("ClimbRung") then
                            v34.CanCollide = u24;
                        end;

                        for _, v2 in v.decals do
                            v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v38);
                        end;
                    else
                        v34.Transparency = 1;
                        v34.CanCollide = false;

                        for _, v2 in v.decals do
                            v2.decal.Transparency = 1;
                        end;
                    end;
                end;
            end;

            local v39 = u25 * v33;

            if v39 <= 0 then
                CollisionBlock.CanCollide = false;

                return;
            end;

            CollisionBlock.Size = Vector3.new(CollisionBlock.Size.X, v39, CollisionBlock.Size.Z);
            CollisionBlock.CFrame = PrimaryPart.CFrame * CFrame.new(0, v39 / 2, 0);
            CollisionBlock.CanCollide = not u24;
        end;

        u23:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end
};