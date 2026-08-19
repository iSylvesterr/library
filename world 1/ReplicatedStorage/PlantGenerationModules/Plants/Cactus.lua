-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 7, Name: InitPlant
        local v4 = (p3 or 1) * 0.5 + 0.5;
        local v5 = Random.new(p2);
        local FruitSpawnLocations = u1.FruitSpawnLocations;
        local Base = u1.Base;
        local u6 = 0;
        local u7 = {};
        local u8 = {};
        local Cactus_Cylinder = script.Cactus_Cylinder;
        local Cactus_Ball = script.Cactus_Ball;
        local Cactus_Prickle = script.Cactus_Prickle;

        if v5:NextNumber() < 0.08 then
            v5:NextNumber(2, 3);
        end;

        u1:SetAttribute("BigSpikes", false);
        local v9 = v5:NextInteger(4, 5);

        while v5:NextInteger(1, 100) == 1 do
            v9 = v9 * 2;
        end;

        local v10 = v5:NextInteger(20, 30) * 0.1 * (v4 * 0.1 + 1);
        local v11 = v5:NextInteger(20, 30) * 0.1 * (v4 * 0.1 + 1);
        local v12 = Vector3.new(v9, v10, v11);

        local function newCylinder(p13, p14) -- Line: 56
            -- upvalues: Cactus_Cylinder (copy), u6 (ref), u1 (copy), u7 (copy), u8 (copy)
            local v15 = Cactus_Cylinder:Clone();
            v15.Size = p13;
            v15.CFrame = p14;
            u6 = u6 + 1;
            v15.Name = tostring(u6);
            v15.Parent = u1;
            table.insert(u7, v15);
            table.insert(u8, v15);

            return v15;
        end;

        local function attachBall(p16, p17) -- Line: 68
            -- upvalues: Cactus_Ball (copy), u6 (ref), u1 (copy), u7 (copy)
            local Y = p16.Size.Y;

            if p16.Size.Z < Y then
                Y = p16.Size.Z;
            end;

            local v18 = Cactus_Ball:Clone();
            v18.Size = Vector3.new(Y, Y, Y);
            v18.CFrame = p16.CFrame * CFrame.new(p16.Size.X / 2, 0, 0);
            u6 = u6 + 1;
            v18.Name = tostring(u6);
            v18.Parent = u1;
            table.insert(u7, v18);

            return v18;
        end;

        local v30, v31 = (function(p19, p20, p21, p22) -- Line: 83, Name: createChain
            -- upvalues: Cactus_Cylinder (copy), u6 (ref), u1 (copy), u7 (copy), u8 (copy), FruitSpawnLocations (copy)
            local v23 = {};
            local v24 = p20.X / 2;
            local v25 = Cactus_Cylinder:Clone();
            v25.Size = p20;
            v25.CFrame = p21;
            u6 = u6 + 1;
            v25.Name = tostring(u6);
            v25.Parent = u1;
            table.insert(u7, v25);
            table.insert(u8, v25);

            if p22 then
                local v26 = script.Spawn_Object:Clone();
                v26.CFrame = v25.CFrame.Rotation + (v25.Position + Vector3.new(0, v25.Size.Y / 2, 0));
                v26.Parent = FruitSpawnLocations;
            end;

            v23[1] = v25;

            for i = 2, p19 do
                local v27 = CFrame.new(v24 * 2, 0, 0);
                local v28 = v25.CFrame * v27;
                v25 = Cactus_Cylinder:Clone();
                v25.Size = p20;
                v25.CFrame = v28;
                u6 = u6 + 1;
                v25.Name = tostring(u6);
                v25.Parent = u1;
                table.insert(u7, v25);
                table.insert(u8, v25);

                if p22 then
                    local v29 = script.Spawn_Object:Clone();
                    v29.CFrame = v25.CFrame * CFrame.new(0, 0, v25.Size.X / 3);
                    v29.Parent = FruitSpawnLocations;
                end;

                v23[i] = v25;
            end;

            return v23, v25;
        end)(v5:NextInteger(2, 3) + v9 * 0.5, v12, Base.CFrame * CFrame.new(0, -Base.Size.Y / 2, 0) * CFrame.Angles(0, 0, 1.5707963267948966), false);
        attachBall(v31, true);
        local v32 = (-1 / 0);
        local v33 = (1 / 0);

        for _, v in u8 do
            if v32 < v.Position.Y then
                v32 = v.Position.Y;
            end;

            if v.Position.Y < v33 then
                v33 = v.Position.Y;
            end;
        end;

        local _ = v32 - v33;
        local CFrame2 = v30[1].CFrame;
        local v34 = (v31.Position - v30[1].Position).Magnitude + v12.X / 2;
        local v35 = math.clamp(v12.X * 0.75, 3, 10);
        local v36 = Vector3.new(v35, v12.Y, v12.Z);
        local v37 = v36.X / 2;
        local v38 = v34 - 5;
        local v39 = 5;
        local v40 = {};

        while true do
            if v39 > v38 then
                local v41 = math.floor(2 * v4 * 1);
                local v42 = math.floor(3 * v4 * 1);

                for _, v in u8 do
                    for i = 1, v5:NextInteger(v41, v42) do
                        if i % 2 ~= 0 then
                            local v43 = Cactus_Prickle:Clone();
                            v43.Size = Vector3.new((v.Size.Y + 0.5) * 1, 0.125, 0.125);
                            local v44 = v.CFrame * CFrame.new(v5:NextNumber(-v.Size.X, v.Size.X) * 0.5, 0, 0);
                            local Angles = CFrame.Angles;
                            local v45 = v5:NextInteger(-180, 180);
                            v43.CFrame = v44 * Angles(math.rad(v45), 1.5707963267948966, 0);
                            u6 = u6 + 1;
                            v43.Name = tostring(u6);
                            v43.Parent = u1;
                            v43:AddTag("DetailPart");
                            v43:SetAttribute("Prickle", true);
                        end;
                    end;
                end;

                for _, child in FruitSpawnLocations:GetChildren() do
                    child.CFrame = child.CFrame * CFrame.Angles(1.5707963267948966, 0, 0);
                end;

                u1:AddTag("InitializationComplete");

                return;
            end;

            local v46 = nil;

            for _ = 1, 5 do
                local v47 = v5:NextInteger(-180, 180);
                local v48 = true;

                for _, v in v40 do
                    if math.abs(v.dist - v39) < 8 and math.abs((v.angle - v47 + 180) % 360 - 180) < 35 then
                        v48 = false;
                        break;
                    end;
                end;

                if v48 then
                    table.insert(v40, {
                        dist = v39,
                        angle = v47
                    });
                    v46 = v47;
                end;
            end;

            if v46 then
                local v49 = CFrame2 * CFrame.new(v39, 0, 0) * CFrame.Angles(math.rad(v46), 1.5707963267948966, 0) * CFrame.new(v37, 0, 0);
                local _ = v36.X / 2;
                local v50 = Cactus_Cylinder:Clone();
                v50.Size = v36;
                v50.CFrame = v49;
                u6 = u6 + 1;
                v50.Name = tostring(u6);
                v50.Parent = u1;
                table.insert(u7, v50);
                table.insert(u8, v50);
                local v51 = script.Spawn_Object:Clone();
                v51.CFrame = v50.CFrame.Rotation + (v50.Position + Vector3.new(0, v50.Size.Y / 2, 0));
                v51.Parent = FruitSpawnLocations;
                ({})[1] = v50;
                attachBall(v50, true);
                local v52 = v50.CFrame * CFrame.new(v37, 0, v37) * CFrame.Angles(0, -1.5707963267948966, 0);
                local v53 = {};
                local v54 = v36.X / 2;
                local v55 = Cactus_Cylinder:Clone();
                v55.Size = v36;
                v55.CFrame = v52;
                u6 = u6 + 1;
                v55.Name = tostring(u6);
                v55.Parent = u1;
                table.insert(u7, v55);
                table.insert(u8, v55);
                v53[1] = v55;
                local v56 = CFrame.new(v54 * 2, 0, 0);
                local v57 = v55.CFrame * v56;
                local v58 = Cactus_Cylinder:Clone();
                v58.Size = v36;
                v58.CFrame = v57;
                u6 = u6 + 1;
                v58.Name = tostring(u6);
                v58.Parent = u1;
                table.insert(u7, v58);
                table.insert(u8, v58);
                v53[2] = v58;
                attachBall(v58, true);
            end;

            v39 = v39 + v5:NextNumber(4, 7);
        end;
    end,

    BeginPlantGrowth = function(u59) -- Line: 225, Name: BeginPlantGrowth
        local PrimaryPart = u59.PrimaryPart;
        local u60 = {};

        for _, v in u59:QueryDescendants("BasePart") do
            local v61 = tonumber(v.Name);

            if v61 then
                local v62 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v61
                };
                table.insert(u60, v62);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        table.sort(u60, function(p63, p64) -- Line: 243
            return p63[4] < p64[4];
        end);

        local function updateGrowth() -- Line: 245
            -- upvalues: u59 (copy), u60 (copy), PrimaryPart (copy)
            local v65 = u59:GetAttribute("Age") or 0;

            for _, v in u60 do
                local v66 = v[1];
                local v67 = v[2];
                local v68 = v[3];
                local v69 = math.clamp(v65 - v[4], 0, 1);

                if v69 ~= v.lastProgress then
                    v.lastProgress = v69;

                    if v69 > 0 then
                        v66.Size = Vector3.new(v67.X * v69, v67.Y, v67.Z);
                        v66.CFrame = PrimaryPart.CFrame * v68 * CFrame.new(-((v67.X - v66.Size.X) / 2), 0, 0);
                        v66.Transparency = v66:GetAttribute("OG_Transparency") or 0;
                        v66.CanCollide = true;
                    else
                        v66.Transparency = 1;
                        v66.CanCollide = false;
                    end;
                end;
            end;

            if game.Players.LocalPlayer and (game:GetService("RunService"):IsClient() and (not u59:GetAttribute("playedSfx") and u59:GetAttribute("MaxAge") <= v65)) then
                u59:SetAttribute("playedSfx", true);
                game.SoundService:PlayLocalSound(game.SoundService.SFX.Happy);
            end;
        end;

        u59:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
        local LocalPlayer = game.Players.LocalPlayer;

        if not LocalPlayer then
            return;
        end;

        if u59:GetAttribute("UserId") == LocalPlayer.UserId then
            return;
        end;

        local u70 = u59:GetAttribute("BigSpikes") and 10 or 5;
        local u71 = 0;

        local function onTouch(p72) -- Line: 289
            -- upvalues: LocalPlayer (copy), u71 (ref), u70 (copy)
            local v73 = p72.Parent and p72.Parent:FindFirstChildOfClass("Humanoid");

            if not v73 or p72.Parent ~= LocalPlayer.Character then
                return;
            end;

            local v74 = os.clock();

            if v74 - u71 < 1 then
                return;
            end;

            u71 = v74;

            if v73.Health > 1 then
                v73.Health = math.max(v73.Health - u70, 0);
            end;
        end;

        for _, v in u59:QueryDescendants("BasePart") do
            v.Touched:Connect(onTouch);
        end;
    end,

    Extras = {}
};