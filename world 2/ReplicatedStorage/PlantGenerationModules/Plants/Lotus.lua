-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(p1, p2, p3) -- Line: 6, Name: InitPlant
        local v4 = Random.new(p2);
        local v5 = {};

        for _, v in p1:QueryDescendants("BasePart") do
            local v6 = tostring(v.Color);

            if not v5[v6] then
                local v7, v8, v9 = v.Color:ToHSV();
                local v10 = (v7 + v4:NextNumber(-0.05, 0.05)) % 1;
                local v11 = v8 + v4:NextNumber(-0.15, 0.15);
                local v12 = math.clamp(v11, 0, 1);
                local v13 = v9 + v4:NextNumber(-0.15, 0.15);
                local v14 = math.clamp(v13, 0, 1);
                v5[v6] = Color3.fromHSV(v10, v12, v14);
            end;

            v.Color = v5[v6];
        end;

        p1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u15) -- Line: 25, Name: BeginPlantGrowth
        local PrimaryPart = u15.PrimaryPart;
        local u16 = {};

        for _, v in u15:QueryDescendants("BasePart") do
            local v17 = tonumber(v.Name);

            if v17 then
                local v18 = v:GetAttribute("OG_Transparency");

                if v18 == nil then
                    v18 = v.Transparency;
                end;

                local v19 = v.Material == Enum.Material.Neon and 0.5 or v18;
                v:SetAttribute("OG_Transparency", v19);
                local v20 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Texture") or child:IsA("Decal") then
                        table.insert(v20, {
                            instance = child,
                            originalTransparency = child.Transparency
                        });
                        child.Transparency = 1;
                    end;
                end;

                local v21 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v17,
                    v19,
                    v20
                };
                table.insert(u16, v21);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 63
            -- upvalues: u15 (copy), u16 (copy), PrimaryPart (copy)
            local v22 = u15:GetAttribute("Age") or 0;
            u15:GetAttribute("MaxAge");

            for _, v in u16 do
                local v23 = v[1];
                local v24 = v[2];
                local v25 = v[3];
                local v26 = v[5];
                local v27 = v[6];
                local v28 = math.min(v22 - v[4], 1);
                local v29 = math.clamp(v28, 0, 1);

                if v29 ~= v.lastProgress then
                    v.lastProgress = v29;

                    if v28 > 0 then
                        v23.Size = Vector3.new(v24.X, v24.Y * v28, v24.Z);
                        v23.CFrame = PrimaryPart.CFrame * v25 * CFrame.new(0, (v23.Size.Y - v24.Y) / 2, 0);
                        v23.Transparency = v26;
                        v23.CanCollide = true;

                        for _, v2 in v27 do
                            v2.instance.Transparency = v2.originalTransparency;
                        end;
                    else
                        v23.Transparency = 1;
                        v23.CanCollide = false;

                        for _, v2 in v27 do
                            v2.instance.Transparency = 1;
                        end;
                    end;
                end;
            end;

            if game.Players.LocalPlayer and (game:GetService("RunService"):IsClient() and (not u15:GetAttribute("playedSfx") and u15:GetAttribute("MaxAge") <= v22)) then
                u15:SetAttribute("playedSfx", true);
                game.SoundService:PlayLocalSound(game.SoundService.SFX.Happy);
            end;
        end;

        u15:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};