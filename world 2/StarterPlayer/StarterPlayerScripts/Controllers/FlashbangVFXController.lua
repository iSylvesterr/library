-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local Lighting = game:GetService("Lighting");
local Debris = game:GetService("Debris");
local SoundService = game:GetService("SoundService");
local CurrentCamera = workspace.CurrentCamera;
local Networking = require(game.ReplicatedStorage.SharedModules.Networking);
local u2 = {
    Init = function(p1) -- Line: 19, Name: Init
    end
};

function u2.Start(p3) -- Line: 21
    -- upvalues: Networking (copy), u2 (copy)
    Networking.Flashbang.Flashbang.OnClientEvent:Connect(function() -- Line: 22
        -- upvalues: u2 (ref)
        u2:Flash(1, 1.75);
    end);
    Networking.Flashbang.Detonate.OnClientEvent:Connect(function() -- Line: 26
        -- upvalues: u2 (ref)
        u2:DetonationFlash();
    end);
end;

local function getOrCreateWhiteFrame() -- Line: 31
    -- upvalues: Players (copy)
    local v4 = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui");

    if not v4 then
        return nil;
    end;

    local FlashbangGui = v4:FindFirstChild("FlashbangGui");

    if not FlashbangGui then
        FlashbangGui = Instance.new("ScreenGui");
        FlashbangGui.Name = "FlashbangGui";
        FlashbangGui.DisplayOrder = 999;
        FlashbangGui.IgnoreGuiInset = true;
        FlashbangGui.ResetOnSpawn = false;
        FlashbangGui.Parent = v4;
    end;

    local WhiteFrame = FlashbangGui:FindFirstChild("WhiteFrame");

    if not WhiteFrame then
        WhiteFrame = Instance.new("Frame");
        WhiteFrame.Name = "WhiteFrame";
        WhiteFrame.Size = UDim2.fromScale(1, 1);
        WhiteFrame.BackgroundColor3 = Color3.new(1, 1, 1);
        WhiteFrame.BackgroundTransparency = 1;
        WhiteFrame.BorderSizePixel = 0;
        WhiteFrame.Parent = FlashbangGui;
    end;

    return WhiteFrame;
end;

function u2.Flash(p5, u6, p7) -- Line: 61
    -- upvalues: getOrCreateWhiteFrame (copy), TweenService (copy), Debris (copy), Lighting (copy), CurrentCamera (copy)
    local u8 = p7 or 0.5;
    task.spawn(function() -- Line: 63
        -- upvalues: u6 (copy), getOrCreateWhiteFrame (ref), TweenService (ref), Debris (ref), Lighting (ref), CurrentCamera (ref), u8 (ref)
        local v9 = TweenInfo.new(u6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local v10 = TweenInfo.new(u6 * 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local v11 = getOrCreateWhiteFrame();
        v11.Parent.Enabled = true;

        if v11 then
            v11.BackgroundTransparency = 1;
            local v12 = TweenService:Create(v11, v9, {
                BackgroundTransparency = 0
            });
            v12:Play();
            Debris:AddItem(v12, v9.Time);
        end;

        local v13 = TweenService:Create(Lighting, v9, {
            ExposureCompensation = 9
        });
        v13:Play();
        Debris:AddItem(v13, v9.Time);
        local v14 = TweenService:Create(CurrentCamera, v9, {
            FieldOfView = 80
        });
        v14:Play();
        Debris:AddItem(v14, v9.Time);
        task.wait(u6 + u8);
        local v15 = TweenService:Create(Lighting, v10, {
            ExposureCompensation = 0
        });
        v15:Play();
        Debris:AddItem(v15, v10.Time);
        local v16 = TweenService:Create(CurrentCamera, v10, {
            FieldOfView = 70
        });
        v16:Play();
        Debris:AddItem(v16, v10.Time);

        if v11 then
            local v17 = TweenService:Create(v11, v10, {
                BackgroundTransparency = 1
            });
            v17:Play();
            Debris:AddItem(v17, v10.Time);
        end;
    end);
end;

function u2.DetonationFlash(p18) -- Line: 100
    -- upvalues: getOrCreateWhiteFrame (copy), TweenService (copy), Debris (copy), Lighting (copy), CurrentCamera (copy), SoundService (copy)
    task.spawn(function() -- Line: 101
        -- upvalues: getOrCreateWhiteFrame (ref), TweenService (ref), Debris (ref), Lighting (ref), CurrentCamera (ref), SoundService (ref)
        local v19 = getOrCreateWhiteFrame();

        if not v19 then
            return;
        end;

        local v20 = TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local v21 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        v19.Parent.Enabled = true;
        v19.BackgroundTransparency = 1;
        local v22 = TweenService:Create(v19, v20, {
            BackgroundTransparency = 0
        });
        v22:Play();
        Debris:AddItem(v22, v20.Time);
        local v23 = TweenService:Create(Lighting, v20, {
            ExposureCompensation = 9
        });
        v23:Play();
        Debris:AddItem(v23, v20.Time);
        local v24 = TweenService:Create(CurrentCamera, v20, {
            FieldOfView = 80
        });
        v24:Play();
        Debris:AddItem(v24, v20.Time);
        local Sound = Instance.new("Sound");
        Sound.SoundId = "rbxassetid://122137666092419";
        Sound.Volume = 2;
        Sound.SoundGroup = SoundService:FindFirstChild("SFXGroup");
        Sound.Parent = v19.Parent;
        Sound:Play();
        Debris:AddItem(Sound, 30);
        task.spawn(function() -- Line: 130
            -- upvalues: Sound (copy), TweenService (ref), Debris (ref)
            if not Sound.IsLoaded then
                Sound.Loaded:Wait();
            end;

            local TimeLength = Sound.TimeLength;

            if TimeLength > 0 and Sound.Parent then
                local v25 = TweenInfo.new(TimeLength, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
                local v26 = TweenService:Create(Sound, v25, {
                    Volume = 0.5
                });
                v26:Play();
                Debris:AddItem(v26, v25.Time);
            end;
        end);
        local v27 = math.random(40, 50) * 0.1;
        task.wait(v27);
        local v28 = TweenService:Create(v19, v21, {
            BackgroundTransparency = 1
        });
        v28:Play();
        Debris:AddItem(v28, v21.Time);
        local v29 = TweenService:Create(Lighting, v21, {
            ExposureCompensation = 0
        });
        v29:Play();
        Debris:AddItem(v29, v21.Time);
        local v30 = TweenService:Create(CurrentCamera, v21, {
            FieldOfView = 70
        });
        v30:Play();
        Debris:AddItem(v30, v21.Time);
    end);
end;

return u2;