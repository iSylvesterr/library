-- Decompiled with Potassium's decompiler.

game:GetService("MaterialService");

return {
    GrowData = {
        GrowRate = 0.0119,
        BaseWeight = 1.5,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 13, Name: InitFruit
        local u4 = Random.new(p2);
        local _ = p3 * 0.2;
        local v5 = p1.Base:GetPivot();

        local function GetRandomHSV(p6, p7) -- Line: 22
            -- upvalues: u4 (copy)
            local v8, v9, v10 = p6:ToHSV();
            local v11 = p7 or 0.05;
            local v12 = (v8 + u4:NextNumber(-v11, v11)) % 1;

            return Color3.fromHSV(v12, math.clamp(v9, 0, 1), (math.clamp(v10, 0, 1))), v12, v9, v10;
        end;

        local function ApplyColorKeepBrightness(p13, p14, p15) -- Line: 30
            local v16 = p15 or 1;

            if p13:IsA("BasePart") then
                local _, _, v17 = p13.Color:ToHSV();
                local v18, v19 = p14:ToHSV();
                p13.Color = Color3.fromHSV(v18, v19 * v16, v17);
            end;
        end;

        local v20, v21 = Color3.fromRGB(109, 209, 73);
        local v22, v23, v24 = v20:ToHSV();
        local v25 = v21 or 0.05;
        local v26 = (v22 + u4:NextNumber(-v25, v25)) % 1;
        local v27 = Color3.fromHSV(v26, math.clamp(v23, 0, 1), (math.clamp(v24, 0, 1)));
        local v28, v29 = Color3.fromRGB(242, 255, 102);
        local v30, v31, v32 = v28:ToHSV();
        local v33 = v29 or 0.05;
        local v34 = (v30 + u4:NextNumber(-v33, v33)) % 1;
        local v35 = Color3.fromHSV(v34, math.clamp(v31, 0, 1), (math.clamp(v32, 0, 1)));
        local v36 = u4:NextInteger(6, 10);

        while u4:NextInteger(1, 4) == 1 do
            v36 = v36 + 1;
        end;

        local v37 = u4:NextNumber(-6, 6);
        local v38 = math.rad(v37);
        local v39 = u4:NextNumber(-6, 6);
        local v40 = math.rad(v39);
        local Angles = CFrame.Angles;
        local v41 = u4:NextNumber(-10, 10);
        local v42 = math.rad(v41);
        local v43 = u4:NextNumber(1, 360);
        local v44 = math.rad(v43);
        local v45 = u4:NextNumber(-10, 10);
        local v46 = v5 * Angles(v42, v44, (math.rad(v45)));
        local v47 = 60;
        local v48 = false;

        for i = 1, v47 do
            if i > 25 and v48 == false then
                v38 = -v38;
                v40 = -v40;
                v48 = true;
            end;

            local v49 = script.Layer:Clone();
            v49.Parent = workspace;
            local v50 = (i - 1) / (v47 - 1);
            v49:ScaleTo(0.9 + -0.55 * v50);
            local v51 = v27:Lerp(v35, v50);

            for _, v in v49:QueryDescendants("BasePart") do
                v.Color = v51;
            end;

            v49:PivotTo(v46);
            v46 = v49:GetPivot() * CFrame.new(0, 2 * v49:GetScale(), 0) * CFrame.Angles(v38, 0, v40);

            for _, child in v49:GetChildren() do
                if child:IsA("BasePart") then
                    local v52 = tonumber(child.Name) + i;
                    child.Name = tostring(v52);
                    child.Parent = p1;
                end;
            end;

            v49:Destroy();
        end;

        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u53) -- Line: 102, Name: BeginFruitGrowth
        local PrimaryPart = u53.PrimaryPart;
        local u54 = {};

        for _, v in u53:QueryDescendants("BasePart") do
            local v55 = tonumber(v.Name);

            if v55 then
                local v56 = not v:GetAttribute("DontShow");
                local v57 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v55
                };
                table.insert(u54, v57);
                v.CanCollide = false;

                if v56 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 123
            -- upvalues: u53 (copy), u54 (copy), PrimaryPart (copy)
            local v58 = u53:GetAttribute("Age") or 0;
            local v59 = u53:GetAttribute("MaxAge") or 1;
            local v60 = v58 / v59;

            for _, v in u54 do
                if not v.part:GetAttribute("DontShow") then
                    local v61 = math.clamp((v60 - v.partAge / v59) * v59, 0, 1);

                    if v61 ~= v.lastProgress then
                        v.lastProgress = v61;

                        if v61 > 0 then
                            local v62 = v.maxSize * v61;
                            v.part.Size = v62;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v62.Y) / 2), 0);
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

        u53:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p63) -- Line: 159, Name: OnFullyGrown
        local v64 = p63:GetAttribute("CorePartName");

        if v64 then
            local v65 = p63:FindFirstChild(v64);
            local v66 = v65 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v66 then
                local v67 = v66:Clone();
                v67.Name = "ProximityPrompt";
                v67.Parent = v65;
            end;
        end;

        p63:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Acorn",
        Harvestable = true
    }
};