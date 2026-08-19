-- Decompiled with Potassium's decompiler.

game:GetService("MaterialService");

return {
    GrowData = {
        GrowRate = 0.0333,
        BaseWeight = 1.125,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 13, Name: InitFruit
        local u4 = Random.new(p2);
        local v5 = p3 * 0.2;

        local function GetRandomHSV(p6, p7) -- Line: 19
            -- upvalues: u4 (copy)
            local v8, v9, v10 = p6:ToHSV();
            local v11 = p7 or 0.05;
            local v12 = (v8 + u4:NextNumber(-v11, v11)) % 1;

            return Color3.fromHSV(v12, math.clamp(v9, 0, 1), (math.clamp(v10, 0, 1))), v12, v9, v10;
        end;

        local v13 = u4:NextNumber(0.1, 1);

        while u4:NextInteger(1, 7) == 1 do
            v13 = v13 + 0.12;
        end;

        local _ = v13 / 2;

        for _, child in p1:GetChildren() do
            if child:GetAttribute("Offset") then
                child.CFrame = child.CFrame * CFrame.new(0, v13, 0);
            end;

            if child:GetAttribute("Scale") then
                child.Size = child.Size + Vector3.new(0, v13, 0);
                child.CFrame = child.CFrame * CFrame.new(0, v5, 0);
            end;
        end;

        local v14 = p1:WaitForChild("3"):GetPivot();
        local Y = p1:WaitForChild("3").Size.Y;
        local v15 = script.SideSpikes:Clone();
        local Angles = CFrame.Angles;
        local v16 = 90 * u4:NextInteger(0, 3);
        v15:PivotTo(v14 * Angles(0, math.rad(v16), 0));

        for _, child in v15:GetChildren() do
            child.Parent = p1;
        end;

        v15:Destroy();
        local v17 = script.SideSpikes:Clone();
        local Angles2 = CFrame.Angles;
        local v18 = 90 * u4:NextInteger(0, 3);
        v17:PivotTo(v14 * Angles2(0, math.rad(v18), 0) * CFrame.new(0, Y / 2.5, 0));

        for _, child in v17:GetChildren() do
            child.Parent = p1;
        end;

        v17:Destroy();
        local v19 = script.SideSpikes:Clone();
        local Angles3 = CFrame.Angles;
        local v20 = 90 * u4:NextInteger(0, 3);
        v19:PivotTo(v14 * Angles3(0, math.rad(v20), 0) * CFrame.new(0, -Y / 2.5, 0));

        for _, child in v19:GetChildren() do
            child.Parent = p1;
        end;

        v19:Destroy();
        p1:ScaleTo(p3);
        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u21) -- Line: 59, Name: BeginFruitGrowth
        local PrimaryPart = u21.PrimaryPart;
        local u22 = {};

        for _, v in u21:QueryDescendants("BasePart") do
            local v23 = tonumber(v.Name);

            if v23 then
                local v24 = not v:GetAttribute("DontShow");
                local v25 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v23
                };
                table.insert(u22, v25);
                v.CanCollide = false;

                if v24 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 80
            -- upvalues: u21 (copy), u22 (copy), PrimaryPart (copy)
            local v26 = u21:GetAttribute("Age") or 0;
            local v27 = u21:GetAttribute("MaxAge") or 1;
            local v28 = v26 / v27;

            for _, v in u22 do
                if not v.part:GetAttribute("DontShow") then
                    local v29 = math.clamp((v28 - v.partAge / v27) * v27, 0, 1);

                    if v29 ~= v.lastProgress then
                        v.lastProgress = v29;

                        if v29 > 0 then
                            local v30 = v.maxSize * v29;
                            v.part.Size = v30;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v30.Y) / 2), 0);
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

        u21:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p31) -- Line: 116, Name: OnFullyGrown
        local v32 = p31:GetAttribute("CorePartName");

        if v32 then
            local v33 = p31:FindFirstChild(v32);
            local v34 = v33 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v34 then
                local v35 = v34:Clone();
                v35.Name = "ProximityPrompt";
                v35.Parent = v33;
            end;
        end;

        p31:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Acorn",
        Harvestable = true
    }
};