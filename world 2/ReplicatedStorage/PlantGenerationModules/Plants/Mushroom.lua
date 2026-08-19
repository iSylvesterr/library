-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25,
        BaseWeight = 5
    },

    InitPlant = function(p1, p2, p3) -- Line: 7, Name: InitPlant
        local v4 = Random.new(p2);
        local Base = p1.Base;
        local v5 = 1;
        local Stud_Part = script.Stud_Part;
        local _ = script.MushroomTop;
        local v6 = 0.5 + (p3 or 1) * 0.5;
        local v7 = 2 + v6 * 0.5;
        local v8 = 7 + v6;
        local v9 = 1;

        if v4:NextInteger(1, 5000) == 1 then
            v9 = v9 * 2;

            while v4:NextInteger(1, 3) == 1 do
                v9 = v9 * 2;
            end;
        end;

        local v10 = (2 + v6) * v9;
        local v11 = Base.CFrame * CFrame.new(0, -Base.Size.Y / 2, 0);
        local Size = Base.Size;
        local v12 = false;
        local v13 = nil;

        for _ = 1, 2 do
            for _ = 1, v7 do
                v13 = Stud_Part:Clone();
                v13.Size = Vector3.new(v8 * 0.75, v10 * 0.75, v8 * 0.75);
                v13.Color = Color3.new(1, 1, 1);
                v13.Name = tostring(v5);
                v13.CFrame = v11 * CFrame.new(0, v13.Size.Y / 2 + Size.Y / 2, 0);

                if v12 == false then
                    v8 = v8 * 0.75;
                    v10 = v10 * 1.25;
                else
                    v8 = v8 * 1.25;
                    v10 = v10 * 0.75;
                end;

                v13.Parent = p1;
                v11 = v13.CFrame;
                Size = v13.Size;
                v5 = v5 + 1;
            end;

            v12 = not v12;
        end;

        local v14 = Color3.fromHSV(v4:NextInteger(0, 20) * 0.05, 1, 0.9);
        local v15 = script.MushroomTop:Clone();
        v15:ScaleTo(v6 * 1.5 ^ math.log(v9, 2));
        v15:PivotTo(v13.CFrame * CFrame.new(0, v13.Size.Y / 2 + v15.PrimaryPart.Size.Y / 2 + 0.01, 0) * CFrame.Angles(0, 0, 3.141592653589793));

        for _, v in v15:QueryDescendants("BasePart") do
            v.AssemblyLinearVelocity = Vector3.new(0, 170 * v6, 0);
        end;

        local v16 = {};

        for _, child in pairs(v15:GetChildren()) do
            if child ~= v15.PRIMARY and child:IsA("BasePart") then
                child:SetAttribute("IsMushroomCap", true);
                table.insert(v16, child);
            end;
        end;

        while #v16 > 0 do
            v5 = v5 + 1;
            local v17 = (-1 / 0);
            local v18 = nil;

            for _, v in pairs(v16) do
                if v17 < v.Position.Y then
                    v17 = v.Position.Y;
                    v18 = v;
                end;
            end;

            if v18 then
                v18.Name = tostring(v5);
                v18.Parent = p1;
                local v19 = table.find(v16, v18);

                if v19 then
                    table.remove(v16, v19);
                end;
            end;
        end;

        for _, child in p1:GetChildren() do
            if child:IsA("BasePart") and child:GetAttribute("IsMushroomCap") then
                child.CanCollide = false;
                child:AddTag("MushroomCap");
            end;
        end;

        v15:Destroy();

        if v4:NextInteger(1, 100) == 1 then
            v14 = Color3.new(0, 0, 0);
        end;

        if v4:NextInteger(1, 100) == 1 then
            for _, child in pairs(p1:GetChildren()) do
                if child:IsA("BasePart") and child.BrickColor == BrickColor.new("Bright red") then
                    child.Color = v14;
                    child.Material = Enum.Material.Neon;
                end;
            end;
        elseif v4:NextInteger(1, 10000) == 1 then
            for _, child in pairs(p1:GetChildren()) do
                if child:IsA("BasePart") and child.BrickColor == BrickColor.new("Bright red") then
                    child.Color = v14;
                    child.Material = Enum.Material.ForceField;
                end;
            end;
        else
            for _, child in pairs(p1:GetChildren()) do
                if child:IsA("BasePart") and child.BrickColor == BrickColor.new("Bright red") then
                    child.Color = v14;
                end;
            end;
        end;

        p1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u20) -- Line: 149, Name: BeginPlantGrowth
        local PrimaryPart = u20.PrimaryPart;
        local u21 = {};

        for _, v in u20:QueryDescendants("BasePart") do
            local v22 = tonumber(v.Name);

            if v22 then
                local v23 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v22
                };
                table.insert(u21, v23);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 165
            -- upvalues: u20 (copy), u21 (copy), PrimaryPart (copy)
            local v24 = u20:GetAttribute("Age") or 0;
            local v25 = u20:GetAttribute("MaxAge") or 1;
            local v26 = v24 / v25;

            for _, v in u21 do
                local v27 = v[1];
                local v28 = v[2];
                local v29 = v[3];
                local v30 = math.min((v26 - v[4] / v25) * v25, 1);
                local v31 = math.clamp(v30, 0, 1);

                if v31 ~= v.lastProgress then
                    v.lastProgress = v31;

                    if v30 > 0 then
                        v27.Size = Vector3.new(v28.X, v28.Y * v30, v28.Z);
                        v27.CFrame = PrimaryPart.CFrame * v29 * CFrame.new(0, (v27.Size.Y - v28.Y) / 2, 0);
                        v27.Transparency = v27:GetAttribute("OG_Transparency") or 0;

                        if v27:GetAttribute("NoCanCollide") == nil then
                            v27.CanCollide = true;
                            v27.CanTouch = true;
                        end;

                        if v27:FindFirstChild("Decal") and v30 >= 1 then
                            for _, v2 in v27:QueryDescendants("> Decal") do
                                v2.Transparency = 0.4;
                            end;
                        end;
                    else
                        v27.Transparency = 1;
                        v27.CanCollide = false;
                        v27.CanTouch = false;
                    end;
                end;
            end;
        end;

        u20:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end
};