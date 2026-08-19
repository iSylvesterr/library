-- Decompiled with Potassium's decompiler.

local Zone = require(game.ReplicatedStorage.SharedModules.Zone);
local Networking = require(game.ReplicatedStorage.SharedModules.Networking);
local ServerClock = require(game.ReplicatedStorage.ClientModules.ServerClock);
local _ = game.Players.LocalPlayer;
local WeatherMachineData = game.ReplicatedStorage.ServerValues.WeatherMachineData;
local TweenService = game:GetService("TweenService");
local CollectionService = game:GetService("CollectionService");
local SoundService = game:GetService("SoundService");

local function playRainbowEffect(p1) -- Line: 20
    -- upvalues: CollectionService (copy), TweenService (copy)
    local u2 = {};

    for _, descendant in ipairs(p1:GetDescendants()) do
        if descendant:IsA("BasePart") and CollectionService:HasTag(descendant, "Colorable") then
            table.insert(u2, {
                part = descendant,
                originalColor = descendant.Color
            });
        end;
    end;

    if #u2 == 0 then
        return;
    end;

    local u3 = TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut);
    task.spawn(function() -- Line: 32
        -- upvalues: u2 (copy), TweenService (ref), u3 (copy)
        for i = 1, 12 do
            local v4 = Color3.fromHSV(i / 12 % 1, 1, 1);

            for _, v in ipairs(u2) do
                TweenService:Create(v.part, u3, {
                    Color = v4
                }):Play();
            end;

            task.wait(0.25);
        end;

        local v5 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

        for _, v in ipairs(u2) do
            if v.part.Parent then
                TweenService:Create(v.part, v5, {
                    Color = v.originalColor
                }):Play();
            end;
        end;
    end);
end;

local function formatCooldown(p6) -- Line: 52
    local v7 = math.floor(p6);
    local v8 = math.max(0, v7);
    local v9 = math.floor(v8 / 60);

    return string.format("%d:%02d", v9, v8 % 60);
end;

local function getCooldownLeft() -- Line: 59
    -- upvalues: WeatherMachineData (copy), ServerClock (copy)
    return (WeatherMachineData:GetAttribute("CooldownUntil") or 0) - ServerClock.Now();
end;

local function updateDisplay(p10, p11) -- Line: 66
    -- upvalues: WeatherMachineData (copy), ServerClock (copy)
    local TextLabel = p10:FindFirstChild("TextLabel");

    if not TextLabel then
        return;
    end;

    local SurfaceGui = TextLabel:FindFirstChild("SurfaceGui");

    if not SurfaceGui then
        return;
    end;

    local TextLabel2 = SurfaceGui:FindFirstChild("TextLabel");

    if not TextLabel2 then
        return;
    end;

    local v12 = (WeatherMachineData:GetAttribute("CooldownUntil") or 0) - ServerClock.Now();
    local Frame = SurfaceGui:FindFirstChild("Frame");

    if Frame then
        Frame = Frame:FindFirstChild("Frame");
    end;

    if v12 <= 0 then
        local v13 = math.clamp(p11, 0, 100);
        TextLabel2.Text = string.format("%.1f", v13) .. "%";
        TextLabel2.TextColor3 = Color3.new(1, 1, 1);

        if Frame then
            Frame.Size = UDim2.new(v13 / 100, 0, 1, 0);
        end;

        Frame.Parent.Visible = true;

        return;
    end;

    local v14 = math.floor(v12);
    local v15 = math.max(0, v14);
    local v16 = math.floor(v15 / 60);
    TextLabel2.Text = string.format("%d:%02d", v16, v15 % 60);
    TextLabel2.TextColor3 = Color3.new(1, 0, 0);

    if Frame then
        Frame.Size = UDim2.new(0, 0, 1, 0);
    end;

    Frame.Parent.Visible = false;
end;

local u17 = {};

local function getOrCreateSFX(p18) -- Line: 98
    -- upvalues: SoundService (copy)
    local v19 = p18.PrimaryPart or p18:FindFirstChildWhichIsA("BasePart");

    if not v19 then
        return nil;
    end;

    local WeatherMachineSFX = v19:FindFirstChild("WeatherMachineSFX");

    if WeatherMachineSFX then
        return WeatherMachineSFX;
    end;

    local Sound = Instance.new("Sound");
    Sound.Name = "WeatherMachineSFX";
    Sound.SoundId = "rbxassetid://134599864373665";
    Sound.Volume = 0;
    Sound.RollOffMaxDistance = 200;
    Sound.Looped = true;
    Sound.SoundGroup = SoundService:FindFirstChild("SFXGroup");
    Sound.Parent = v19;

    return Sound;
end;

local function updateModel(p20, p21) -- Line: 116
    -- upvalues: getOrCreateSFX (copy), u17 (copy), TweenService (copy)
    if not (p20 and p20.Parent) then
        return;
    end;

    if not p20:FindFirstChild("plr_Val") then
        return;
    end;

    local v22 = p21 > 0;
    p20.plr_Val.Value = p21;

    for _, descendant in ipairs(p20:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = v22;
        end;
    end;

    local u23 = getOrCreateSFX(p20);

    if u23 then
        if u17[p20] then
            u17[p20]:Cancel();
            u17[p20] = nil;
        end;

        if v22 then
            if not u23.Playing then
                u23:Play();
            end;

            local v24 = TweenService:Create(u23, TweenInfo.new(1), {
                Volume = 1
            });
            v24:Play();
            u17[p20] = v24;
        else
            local v25 = TweenService:Create(u23, TweenInfo.new(1), {
                Volume = 0
            });
            v25:Play();
            u17[p20] = v25;
            v25.Completed:Once(function() -- Line: 147
                -- upvalues: u23 (copy)
                if u23.Volume <= 0.01 then
                    u23:Stop();
                end;
            end);
        end;
    end;

    local Icon = p20:FindFirstChild("Icon");

    if Icon and Icon:FindFirstChild("Decal") then
        Icon.Decal.Color3 = v22 and Color3.new(0, 0.666667, 1) or Color3.new(1, 1, 1);
    end;

    local Speed_MULTI = p20:FindFirstChild("Speed_MULTI");

    if Speed_MULTI then
        local SurfaceGui = Speed_MULTI:FindFirstChild("SurfaceGui");

        if SurfaceGui then
            SurfaceGui = SurfaceGui:FindFirstChild("TextLabel");
        end;

        if SurfaceGui then
            local v26 = tostring(p21);
            local v27 = #game.Players:GetPlayers();
            SurfaceGui.Text = v26 .. "/" .. tostring(v27);
        end;
    end;
end;

return function(u28) -- Line: 172
    -- upvalues: updateDisplay (copy), WeatherMachineData (copy), ServerClock (copy), playRainbowEffect (copy), updateModel (copy), Zone (copy), Networking (copy)
    local v29 = 0;

    while true do
        local v30 = u28:GetAttribute("UserId");
        local v31;

        if typeof(v30) == "number" then
            v31 = game:GetService("Players"):GetPlayerByUserId(v30);
        else
            v31 = nil;
        end;

        if not v31 then
            v29 = v29 + 1;
            task.wait(0.5);
        end;

        if v31 or v29 >= 20 then
            if not v31 then
                return;
            end;

            local Fill_Val = u28:FindFirstChild("Fill_Val");

            if not Fill_Val then
                return;
            end;

            local u32 = u28:GetAttribute("PropId");

            if not u32 then
                return;
            end;

            updateDisplay(u28, Fill_Val.Value);
            Fill_Val:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 195
                -- upvalues: updateDisplay (ref), u28 (copy), Fill_Val (copy)
                updateDisplay(u28, Fill_Val.Value);
            end);
            task.spawn(function() -- Line: 200
                -- upvalues: u28 (copy), WeatherMachineData (ref), ServerClock (ref), updateDisplay (ref), Fill_Val (copy)
                while u28.Parent do
                    if (WeatherMachineData:GetAttribute("CooldownUntil") or 0) - ServerClock.Now() > 0 then
                        updateDisplay(u28, Fill_Val.Value);
                    end;

                    task.wait(1);
                end;
            end);
            WeatherMachineData:GetAttributeChangedSignal("CooldownUntil"):Connect(function() -- Line: 209
                -- upvalues: updateDisplay (ref), u28 (copy), Fill_Val (copy), WeatherMachineData (ref), ServerClock (ref), playRainbowEffect (ref)
                updateDisplay(u28, Fill_Val.Value);

                if (WeatherMachineData:GetAttribute("CooldownUntil") or 0) - ServerClock.Now() > 0 then
                    playRainbowEffect(u28);
                end;
            end);
            local u33 = {};

            local function connectToData(p34) -- Line: 218
                -- upvalues: u33 (copy), u32 (copy), Fill_Val (copy), updateModel (ref), u28 (copy)
                if u33[p34] then
                    return;
                end;

                if p34.Name ~= u32 then
                    return;
                end;

                local v35 = {};
                u33[p34] = v35;
                local Fill_Value = p34:FindFirstChild("Fill_Value");
                local Active_Players = p34:FindFirstChild("Active_Players");

                if not (Fill_Value and Active_Players) then
                    return;
                end;

                Fill_Val.Value = Fill_Value.Value;
                local v36 = Fill_Value:GetPropertyChangedSignal("Value");
                table.insert(v35, v36:Connect(function() -- Line: 232
                    -- upvalues: Fill_Val (ref), Fill_Value (copy)
                    Fill_Val.Value = Fill_Value.Value;
                end));

                local function refreshModel() -- Line: 236
                    -- upvalues: updateModel (ref), u28 (ref), Active_Players (copy)
                    updateModel(u28, #Active_Players:GetChildren());
                end;

                updateModel(u28, #Active_Players:GetChildren());
                table.insert(v35, Active_Players.ChildAdded:Connect(refreshModel));
                table.insert(v35, Active_Players.ChildRemoved:Connect(refreshModel));
                table.insert(v35, game.Players.PlayerAdded:Connect(refreshModel));
            end;

            local function disconnectData(p37) -- Line: 246
                -- upvalues: u33 (copy)
                local v38 = u33[p37];

                if not v38 then
                    return;
                end;

                for _, v in ipairs(v38) do
                    v:Disconnect();
                end;

                u33[p37] = nil;
            end;

            for _, child in ipairs(WeatherMachineData:GetChildren()) do
                connectToData(child);
            end;

            WeatherMachineData.ChildAdded:Connect(connectToData);
            WeatherMachineData.ChildRemoved:Connect(disconnectData);

            for _, descendant in ipairs(u28:GetDescendants()) do
                if descendant:IsA("Script") then
                    descendant.Enabled = true;
                end;
            end;

            local ZONE = u28:WaitForChild("ZONE", 10);

            if not ZONE then
                return;
            end;

            ZONE.CanQuery = true;
            local v39 = Zone.new(ZONE);
            local Name = v31.Name;
            v39.localPlayerEntered:Connect(function() -- Line: 277
                -- upvalues: u32 (copy), Name (copy), Networking (ref)
                if not (u32 and Name) then
                    return;
                end;

                Networking.WeatherMachine.PlayerEntered:Fire(Name, u32);
            end);
            v39.localPlayerExited:Connect(function() -- Line: 282
                -- upvalues: u32 (copy), Name (copy), Networking (ref)
                if not (u32 and Name) then
                    return;
                end;

                Networking.WeatherMachine.PlayerExited:Fire(Name, u32);
            end);

            return;
        end;
    end;
end;