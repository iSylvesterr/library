-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        GrowRate = 1,
        BaseWeight = 500,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 9, Name: InitFruit
        local v4 = Random.new(p2):NextInteger(2, 3) * p3;
        local Part = Instance.new("Part");
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.Size = Vector3.new(v4, v4, v4);
        Part.Name = "1";
        Part.CFrame = p1.PrimaryPart.CFrame * CFrame.new(0, p1.PrimaryPart.Size.Y / 2 + Part.Size.Y / 2, 0);
        Part.Parent = p1;
        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u5) -- Line: 23, Name: BeginFruitGrowth
        local PrimaryPart = u5.PrimaryPart;
        local u6 = {};

        for _, v in u5:QueryDescendants("BasePart") do
            local v7 = tonumber(v.Name);

            if v7 then
                local v8 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v7
                };
                table.insert(u6, v8);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 41
            -- upvalues: u5 (copy), u6 (copy), PrimaryPart (copy)
            local v9 = u5:GetAttribute("Age") or 0;

            for _, v in u6 do
                local v10 = v[1];
                local v11 = v[2];
                local v12 = v[3];
                local v13 = math.min(v9 - v[4], 1);
                local v14 = math.clamp(v13, 0, 1);

                if v14 ~= v.lastProgress then
                    v.lastProgress = v14;

                    if v13 > 0 then
                        v10.Size = Vector3.new(v11.X, v11.Y * v13, v11.Z);
                        v10.CFrame = PrimaryPart.CFrame * v12 * CFrame.new(0, (v10.Size.Y - v11.Y) / 2, 0);
                        v10.Transparency = v10:GetAttribute("OG_Transparency") or 0;
                        v10.CanCollide = true;

                        if v10.Name == "4" then
                            v10.CFrame = PrimaryPart.CFrame * v12;
                        end;
                    else
                        v10.Transparency = 1;
                        v10.CanCollide = false;
                    end;
                end;
            end;
        end;

        u5:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};