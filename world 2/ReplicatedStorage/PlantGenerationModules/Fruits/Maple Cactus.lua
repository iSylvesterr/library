-- Decompiled with Potassium's decompiler.

local Stud_Part = script.Stud_Part;

return {
    GrowData = {
        GrowRate = 0.0119,
        BaseWeight = 1.5,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(u1, p2, u3) -- Line: 11, Name: InitFruit
        -- upvalues: Stud_Part (copy)
        local u4 = Random.new(p2);
        local PrimaryPart = u1.PrimaryPart;
        local u5 = Stud_Part:Clone();
        u5.Anchored = true;
        u5.Parent = u1;
        local v6 = Color3.new(0.666667, 0.309804, 0.0156863);

        if u4:NextInteger(1, 100) == 1 then
            v6 = Color3.new(1, 0.698039, 0.698039);
        end;

        u5.Color = v6;
        u5.CFrame = PrimaryPart.CFrame;
        local v7 = 2 * u3;
        local Size = u5.Size;
        u5.Size = Vector3.new(v7, v7, v7);
        u5.CFrame = u5.CFrame * CFrame.new(0, (u5.Size.Y - Size.Y) / 2, 0);
        u5.Name = "1";
        local u8 = {};

        for _, child in script.fade:GetChildren() do
            child:Clone().Parent = u5;
        end;

        local Spike = script.Spike;

        local function CreateSpikesOnFace(p9, p10) -- Line: 49
            -- upvalues: u4 (copy), u3 (copy), u5 (copy), Spike (copy), u1 (copy), u8 (copy)
            for _ = 1, u4:NextInteger(1, 3) ~= 1 and 1 or u4:NextInteger(2, 3) do
                local v11 = u4:NextInteger(20, 40) * 0.01 * u3;

                if u4:NextInteger(1, 3) == 1 then
                    v11 = v11 * 1.5;

                    if u4:NextInteger(1, 3) == 1 then
                        v11 = v11 * 1.25;
                    end;
                end;

                local v12;

                if p9 == "X" then
                    v12 = u5.Size.Z / 2;
                else
                    v12 = u5.Size.X / 2;
                end;

                local v13 = u5.Size.Y / 2 - v11;
                local v14 = (u4:NextNumber() * 2 - 1) * v13;
                local v15 = (u4:NextNumber() * 2 - 1) * (v12 - v11);
                local v16 = Spike:Clone();
                local v17, v18;

                if p9 == "X" then
                    v17 = u5.CFrame * CFrame.new(p10 * u5.Size.X / 2, 0, 0) * CFrame.new(0, v14, v15);
                    v18 = CFrame.Angles(0, 0, (math.rad(-90 * p10)));
                else
                    v17 = u5.CFrame * CFrame.new(0, 0, p10 * u5.Size.Z / 2) * CFrame.new(v15, v14, 0);
                    v18 = CFrame.Angles(0, math.rad(-90 * p10), (math.rad(90 * p10)));

                    if p10 == 1 then
                        v18 = v18 * CFrame.Angles(3.141592653589793, 0, 0);
                    end;
                end;

                v16.Size = Vector3.new(v11, v11 * 0.8, v11);
                v16.CFrame = v17 * v18 * CFrame.new(0, v16.Size.Y / 2, 0);
                v16.Parent = u1;
                table.insert(u8, v16);
            end;
        end;

        CreateSpikesOnFace("X", 1);
        CreateSpikesOnFace("X", -1);
        CreateSpikesOnFace("Z", 1);
        CreateSpikesOnFace("Z", -1);
        local v19 = Stud_Part:Clone();
        v19.Parent = u1;
        v19.Color = Color3.fromHSV(u4:NextInteger(80, 95) * 0.001, 1, 0.5);
        v19.Size = Vector3.new(1 * u3, v19.Size.Y * 0.05, 1 * u3);
        v19.CFrame = u5.CFrame * CFrame.new(0, u5.Size.Y / 2 + v19.Size.Y / 2, 0);
        v19.Name = "2";
        local v20 = {
            {
                offset = CFrame.new(v19.Size.X / 2, 0, 0),
                preRot = CFrame.Angles(0, 1.5707963267948966, 0),
                tilt = CFrame.Angles(0.7853981633974483, 0, 0)
            },
            {
                offset = CFrame.new(-v19.Size.X / 2, 0, 0),
                preRot = CFrame.Angles(0, 1.5707963267948966, 0),
                tilt = CFrame.Angles(-0.7853981633974483, 0, 0)
            },
            {
                offset = CFrame.new(0, 0, -v19.Size.Z / 2),
                preRot = CFrame.new(),
                tilt = CFrame.Angles(-0.7853981633974483, 0, 0)
            },
            {
                offset = CFrame.new(0, 0, v19.Size.Z / 2),
                preRot = CFrame.new(),
                tilt = CFrame.Angles(0.7853981633974483, 0, 0)
            }
        };
        local v21 = Vector3.new(v19.Size.X, v19.Size.X, v19.Size.Y * 2);
        local v22 = {};

        for _, v in v20 do
            local v23 = v19:Clone();
            v23.Color = Color3.new(1, 0.470588, 0.117647);
            v23.Size = v21;
            v23.CFrame = v19.CFrame * v.offset;
            v23.Parent = u1;
            v23.CFrame = v23.CFrame * v.preRot;
            v23.CFrame = v23.CFrame * v.tilt;
            v23.CFrame = v23.CFrame * CFrame.new(0, v21.Y / 2, 0);

            for _, child in script.fade:GetChildren() do
                child:Clone().Parent = v23;
            end;

            v23.Name = "3";
            table.insert(v22, v23);
        end;

        for _, v in u8 do
            v.Color = Color3.new(0.870588, 0.654902, 0.101961);
            v.Name = "4";
        end;

        for _, child in u1:GetChildren() do
            if child:IsA("BasePart") then
                child.CanCollide = false;
                child.CanQuery = true;
            end;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u24) -- Line: 174, Name: BeginFruitGrowth
        local PrimaryPart = u24.PrimaryPart;
        local u25 = {};

        for _, v in u24:QueryDescendants("BasePart") do
            local v26 = tonumber(v.Name);

            if v26 then
                local v27 = not v:GetAttribute("DontShow");
                local v28 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v26
                };
                table.insert(u25, v28);
                v.CanCollide = false;

                if v27 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 197
            -- upvalues: u24 (copy), u25 (copy), PrimaryPart (copy)
            local v29 = u24:GetAttribute("Age") or 0;
            local v30 = u24:GetAttribute("MaxAge") or 1;
            local v31 = v29 / v30;

            for _, v in u25 do
                if not v.part:GetAttribute("DontShow") then
                    local v32 = math.clamp((v31 - (v.partAge - 1) / v30) * v30, 0, 1);

                    if v32 ~= v.lastProgress then
                        v.lastProgress = v32;

                        if v32 > 0 then
                            v.part.Size = v.maxSize * v32;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset;
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;
                        else
                            v.part.Transparency = 1;
                            v.part.CanCollide = false;
                        end;
                    end;
                end;
            end;
        end;

        u24:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p33) -- Line: 230, Name: OnFullyGrown
        local v34 = p33:GetAttribute("CorePartName");

        if v34 then
            local v35 = p33:FindFirstChild(v34);
            local v36 = v35 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v36 then
                local v37 = v36:Clone();
                v37.Name = "ProximityPrompt";
                v37.Parent = v35;
            end;
        end;

        p33:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Cactus",
        Harvestable = true
    }
};