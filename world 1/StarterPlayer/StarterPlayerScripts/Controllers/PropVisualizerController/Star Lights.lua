-- Decompiled with Potassium's decompiler.

local Networking = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Networking"));
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local SmartProximityPrompt = require(game:GetService("ReplicatedStorage"):WaitForChild("ClientModules"):WaitForChild("SmartProximityPrompt"));
local u1 = {
    Color3.fromRGB(255, 255, 255),
    Color3.fromRGB(255, 60, 60),
    Color3.fromRGB(255, 150, 60),
    Color3.fromRGB(255, 235, 80),
    Color3.fromRGB(255, 130, 200),
    Color3.fromRGB(170, 95, 255),
    Color3.fromRGB(80, 255, 120),
    Color3.fromRGB(80, 160, 255)
};

return function(u2) -- Line: 21
    -- upvalues: Players (copy), u1 (copy), RunService (copy), SmartProximityPrompt (copy), Networking (copy)
    while true do
        local v3 = u2:GetAttribute("UserId");
        local v4;

        if typeof(v3) == "number" then
            v4 = Players:GetPlayerByUserId(v3);
        else
            v4 = nil;
        end;

        if not v4 then
            task.wait();
        end;

        if v4 then
            local function extractNameNumber(p5) -- Line: 31
                local v6 = p5:match("(%d+)");

                return v6 and tonumber(v6) or nil;
            end;

            local function isNight() -- Line: 36
                return workspace:GetAttribute("ActivePhase") == "Night";
            end;

            local function clampColorId(p7) -- Line: 41
                -- upvalues: u1 (ref)
                local v8 = tonumber(p7) or 1;

                return (math.floor(v8) - 1) % #u1 + 1;
            end;

            local function parseColorId(p9) -- Line: 49
                -- upvalues: u1 (ref)
                if type(p9) == "number" then
                    local v10 = tonumber(p9) or 1;

                    return (math.floor(v10) - 1) % #u1 + 1;
                end;

                if type(p9) ~= "string" then
                    return 1;
                end;

                local v11 = p9:match("(%d+)");
                local v12 = tonumber(v11) or 1;
                local v13 = tonumber(v12) or 1;

                return (math.floor(v13) - 1) % #u1 + 1;
            end;

            local function collectBulbs(p14) -- Line: 60
                local v15 = {};
                local v16 = {};

                for _, descendant in (p14:FindFirstChild("Build") or p14):GetDescendants() do
                    if descendant:IsA("BasePart") then
                        local v17 = descendant:GetAttribute("String");
                        local v18 = tonumber(v17);

                        if v18 then
                            v15[v18] = v15[v18] or {};
                            table.insert(v15[v18], descendant);
                        end;
                    end;
                end;

                for i, v in v15 do
                    table.sort(v, function(p19, p20) -- Line: 78
                        local v21 = tonumber(p19:GetAttribute("Index"));
                        local v22 = tonumber(p20:GetAttribute("Index"));

                        if v21 and (v22 and v21 ~= v22) then
                            return v21 < v22;
                        end;

                        local v23 = p19.Name:match("(%d+)");
                        local v24 = v23 and tonumber(v23) or nil;
                        local v25 = p20.Name:match("(%d+)");
                        local v26 = v25 and tonumber(v25) or nil;

                        if v24 and (v26 and v24 ~= v26) then
                            return v24 < v26;
                        end;

                        local Position = p19.Position;
                        local Position2 = p20.Position;

                        if Position.X ~= Position2.X then
                            return Position.X < Position2.X;
                        end;

                        if Position.Z == Position2.Z then
                            return Position.Y < Position2.Y;
                        end;

                        return Position.Z < Position2.Z;
                    end);

                    for i2, v2 in ipairs(v) do
                        local v27 = {};

                        for _, child in v2:GetChildren() do
                            if child:IsA("Light") then
                                table.insert(v27, {
                                    Obj = child,
                                    BaseBrightness = child.Brightness
                                });
                            end;
                        end;

                        v16[v2] = {
                            StringId = i,
                            Index = i2,
                            Lights = v27
                        };
                    end;
                end;

                return v15, v16;
            end;

            local u28 = nil;

            local function applyToPart(p29, p30, p31, p32) -- Line: 121
                p29.Material = Enum.Material.Neon;
                p29.Color = p31;

                for _, v in ipairs(p30.Lights) do
                    local Obj = v.Obj;

                    if Obj and Obj.Parent then
                        Obj.Color = p31;
                        Obj.Brightness = v.BaseBrightness * p32;
                    end;
                end;
            end;

            local function applyStyle(p33) -- Line: 134
                -- upvalues: u28 (ref), u1 (ref), collectBulbs (copy), u2 (copy), applyToPart (copy), RunService (ref)
                if u28 then
                    u28:Disconnect();
                    u28 = nil;
                end;

                local v34 = tonumber(p33) or 1;
                local v35 = u1[(math.floor(v34) - 1) % #u1 + 1];
                local u36, u37 = collectBulbs(u2);
                local u38, u39, _ = v35:ToHSV();
                local u40 = workspace:GetAttribute("ActivePhase") == "Night" and 1 or 0.5;
                local u41 = workspace:GetAttribute("ActivePhase") == "Night";

                local function getColor(p42) -- Line: 149
                    -- upvalues: u38 (copy), u39 (copy)
                    return Color3.fromHSV(u38, u39, p42);
                end;

                local function getBrightMul(p43) -- Line: 153
                    return (p43 - 0.5) / 0.5 * 0.85 + 0.15;
                end;

                local u44 = u40;
                local u45 = 1;

                for _, v in u36 do
                    for _, v2 in ipairs(v) do
                        local v46 = u37[v2];

                        if v46 then
                            applyToPart(v2, v46, Color3.fromHSV(u38, u39, u40), (u40 - 0.5) / 0.5 * 0.85 + 0.15);
                        end;
                    end;
                end;

                u28 = RunService.RenderStepped:Connect(function(p47) -- Line: 166
                    -- upvalues: u2 (ref), u28 (ref), u41 (ref), u44 (ref), u45 (ref), u40 (ref), u38 (copy), u39 (copy), u36 (copy), u37 (copy), applyToPart (ref)
                    if not u2.Parent then
                        if u28 then
                            u28:Disconnect();
                            u28 = nil;
                        end;

                        return;
                    end;

                    local v48 = workspace:GetAttribute("ActivePhase") == "Night";

                    if v48 ~= u41 then
                        u41 = v48;
                        u44 = v48 and 1 or 0.5;
                        u45 = 0;
                    end;

                    if u45 >= 1 then
                        return;
                    end;

                    u45 = math.min(u45 + p47, 1);
                    local v49 = u45 / 1;
                    local v50 = u44 == 1 and 0.5 or 1;
                    u40 = v50 + (u44 - v50) * (v49 * v49 * (3 - v49 * 2));
                    local v51 = Color3.fromHSV(u38, u39, u40);
                    local v52 = (u40 - 0.5) / 0.5 * 0.85 + 0.15;

                    for _, v in u36 do
                        for _, v2 in ipairs(v) do
                            local v53 = u37[v2];

                            if v53 then
                                applyToPart(v2, v53, v51, v52);
                            end;
                        end;
                    end;
                end);
            end;

            local function applyFromAttribute() -- Line: 208
                -- upvalues: u2 (copy), u1 (ref), applyStyle (copy)
                local v54 = u2:GetAttribute("ExtraData");
                local v55;

                if type(v54) == "number" then
                    local v56 = tonumber(v54) or 1;
                    v55 = (math.floor(v56) - 1) % #u1 + 1;
                elseif type(v54) == "string" then
                    local v57 = v54:match("(%d+)");
                    local v58 = tonumber(v57) or 1;
                    local v59 = tonumber(v58) or 1;
                    v55 = (math.floor(v59) - 1) % #u1 + 1;
                else
                    v55 = 1;
                end;

                applyStyle(v55);
            end;

            local v60 = u2:GetAttribute("ExtraData");
            local v61;

            if type(v60) == "number" then
                local v62 = tonumber(v60) or 1;
                v61 = (math.floor(v62) - 1) % #u1 + 1;
            elseif type(v60) == "string" then
                local v63 = v60:match("(%d+)");
                local v64 = tonumber(v63) or 1;
                local v65 = tonumber(v64) or 1;
                v61 = (math.floor(v65) - 1) % #u1 + 1;
            else
                v61 = 1;
            end;

            applyStyle(v61);
            u2:GetAttributeChangedSignal("ExtraData"):Connect(applyFromAttribute);

            if v4 == Players.LocalPlayer then
                local Primary = u2:FindFirstChild("Primary");

                if Primary and Primary:FindFirstChild("ChangeColour") then
                    local ChangeColour = Primary.ChangeColour;

                    if ChangeColour and ChangeColour:IsA("ProximityPrompt") then
                        SmartProximityPrompt.AttachToModel(ChangeColour, u2, {
                            PartName = "ChangeColourPart",
                            MaxActivationDistance = 10,
                            TrackDistance = 24,
                            SurfaceOffset = 0.75,
                            FollowSpeed = 18
                        });
                        ChangeColour.Triggered:Connect(function() -- Line: 235
                            -- upvalues: u2 (copy), u1 (ref), Networking (ref)
                            local v66 = u2:GetAttribute("ExtraData");
                            local v67;

                            if type(v66) == "number" then
                                local v68 = tonumber(v66) or 1;
                                v67 = (math.floor(v68) - 1) % #u1 + 1;
                            elseif type(v66) == "string" then
                                local v69 = v66:match("(%d+)");
                                local v70 = tonumber(v69) or 1;
                                local v71 = tonumber(v70) or 1;
                                v67 = (math.floor(v71) - 1) % #u1 + 1;
                            else
                                v67 = 1;
                            end;

                            local v72 = tonumber(v67 + 1) or 1;
                            local v73 = (math.floor(v72) - 1) % #u1 + 1;
                            local v74 = u2:GetAttribute("PropId") or u2.Name;
                            Networking.Prop.SetPropExtraData:Fire(v74, (tostring(v73)));
                        end);
                    end;
                end;

                return;
            end;

            local Primary = u2:FindFirstChild("Primary");

            if Primary then
                Primary:ClearAllChildren();
            end;

            return;
        end;
    end;
end;