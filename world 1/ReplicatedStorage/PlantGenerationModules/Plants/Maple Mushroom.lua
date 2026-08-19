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
        local v12 = Color3.fromRGB(214, 146, 91);
        local v13 = Color3.fromRGB(255, 213, 170);
        local v14 = 2 * v7;
        local v15 = false;
        local v16 = nil;

        for _ = 1, 2 do
            for _ = 1, v7 do
                v16 = Stud_Part:Clone();
                v16.Size = Vector3.new(v8 * 0.75, v10 * 0.75, v8 * 0.75);
                v16.Color = Color3.new(1, 1, 1);
                v16.Color = v12:Lerp(v13, (v5 - 1) / math.max(v14 - 1, 1));

                for _, child in script.fade:GetChildren() do
                    local v17 = child:Clone();
                    v17.Color3 = Color3.fromRGB(214, 146, 91);
                    v17.Parent = v16;
                end;

                v16.Name = tostring(v5);
                v16.CFrame = v11 * CFrame.new(0, v16.Size.Y / 2 + Size.Y / 2, 0);

                if v15 == false then
                    v8 = v8 * 0.75;
                    v10 = v10 * 1.25;
                else
                    v8 = v8 * 1.25;
                    v10 = v10 * 0.75;
                end;

                v16.Parent = p1;
                v11 = v16.CFrame;
                Size = v16.Size;
                v5 = v5 + 1;
            end;

            v15 = not v15;
        end;

        local v18 = Color3.fromHSV(v4:NextInteger(0, 20) * 0.05, 1, 0.9);
        local v19 = script.MushroomTop:Clone();
        v19:ScaleTo(v6 * 1.5 ^ math.log(v9, 2));
        v19:PivotTo(v16.CFrame * CFrame.new(0, v16.Size.Y / 2 + v19.PrimaryPart.Size.Y / 2 + 0.01, 0) * CFrame.Angles(0, 0, 3.141592653589793));

        for _, v in v19:QueryDescendants("BasePart") do
            v.AssemblyLinearVelocity = Vector3.new(0, 170 * v6, 0);
        end;

        local v20 = {};

        for _, child in pairs(v19:GetChildren()) do
            if child ~= v19.PRIMARY and child:IsA("BasePart") then
                child:SetAttribute("IsMushroomCap", true);
                table.insert(v20, child);
            end;
        end;

        while #v20 > 0 do
            v5 = v5 + 1;
            local v21 = (-1 / 0);
            local v22 = nil;

            for _, v in pairs(v20) do
                if v21 < v.Position.Y then
                    v21 = v.Position.Y;
                    v22 = v;
                end;
            end;

            if v22 then
                v22.Name = tostring(v5);
                v22.Parent = p1;
                local v23 = table.find(v20, v22);

                if v23 then
                    table.remove(v20, v23);
                end;
            end;
        end;

        for _, child in p1:GetChildren() do
            if child:IsA("BasePart") and child:GetAttribute("IsMushroomCap") then
                child.CanCollide = false;
                child:AddTag("MushroomCap");
            end;
        end;

        v19:Destroy();

        if v4:NextInteger(1, 100) == 1 then
            v18 = Color3.new(0, 0, 0);
        end;

        if v4:NextInteger(1, 100) == 1 then
            for _, child in pairs(p1:GetChildren()) do
                if child:IsA("BasePart") and child.BrickColor == BrickColor.new("Bright red") then
                    child.Color = v18;
                    child.Material = Enum.Material.Neon;
                end;
            end;
        elseif v4:NextInteger(1, 10000) == 1 then
            for _, child in pairs(p1:GetChildren()) do
                if child:IsA("BasePart") and child.BrickColor == BrickColor.new("Bright red") then
                    child.Color = v18;
                    child.Material = Enum.Material.ForceField;
                end;
            end;
        else
            for _, child in pairs(p1:GetChildren()) do
                if child:IsA("BasePart") and child.BrickColor == BrickColor.new("Bright red") then
                    child.Color = v18;

                    if v4:NextInteger(1, 5) == 1 and not child:GetAttribute("iscollision") then
                        for _, child2 in script.fade:GetChildren() do
                            child2:Clone().Parent = child;
                        end;
                    end;
                end;
            end;
        end;

        p1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u24) -- Line: 172, Name: BeginPlantGrowth
        local PrimaryPart = u24.PrimaryPart;
        local u25 = {};

        for _, v in u24:QueryDescendants("BasePart") do
            local v26 = tonumber(v.Name);

            if v26 then
                local v27 = not v:GetAttribute("DontShow");
                local v28 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v28, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v27 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v29 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v26,
                    decals = v28
                };
                table.insert(u25, v29);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 205
            -- upvalues: u24 (copy), u25 (copy), PrimaryPart (copy)
            local v30 = u24:GetAttribute("Age") or 0;
            local v31 = u24:GetAttribute("MaxAge") or 1;
            local v32 = v30 / v31;

            for _, v in u25 do
                local v33 = v[1];
                local v34 = v[2];
                local v35 = v[3];
                local v36 = math.min((v32 - v[4] / v31) * v31, 1);
                local v37 = math.clamp(v36, 0, 1);

                if v37 ~= v.lastProgress then
                    v.lastProgress = v37;

                    if v36 > 0 then
                        v33.Size = Vector3.new(v34.X, v34.Y * v36, v34.Z);
                        v33.CFrame = PrimaryPart.CFrame * v35 * CFrame.new(0, (v33.Size.Y - v34.Y) / 2, 0);
                        v33.Transparency = v33:GetAttribute("OG_Transparency") or 0;

                        if v33:GetAttribute("NoCanCollide") == nil then
                            v33.CanCollide = true;
                            v33.CanTouch = true;
                        end;

                        for _, v2 in v.decals do
                            v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v37);
                        end;
                    else
                        for _, v2 in v.decals do
                            v2.decal.Transparency = 1;
                        end;

                        v33.Transparency = 1;
                        v33.CanCollide = false;
                        v33.CanTouch = false;
                    end;
                end;
            end;
        end;

        u24:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end
};