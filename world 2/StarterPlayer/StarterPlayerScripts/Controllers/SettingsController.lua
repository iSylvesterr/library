-- Decompiled with Potassium's decompiler.

local v1 = {};
local TweenService = game:GetService("TweenService");
local SoundService = game:GetService("SoundService");
local u2 = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0);
local SFXGroup = game.SoundService.SFXGroup;
local GameMusic = game.SoundService.Master.GameMusic;
local LocalPlayer = game.Players.LocalPlayer;
local Settings = LocalPlayer:WaitForChild("Settings");
local Music_Volume = Settings:WaitForChild("Music_Volume");
local SFX_Volume = Settings:WaitForChild("SFX_Volume");

local function getMegaphoneGroup() -- Line: 30
    -- upvalues: SoundService (copy)
    local MegaphoneGroup = SoundService:FindFirstChild("MegaphoneGroup");

    if MegaphoneGroup and MegaphoneGroup:IsA("SoundGroup") then
        return MegaphoneGroup;
    end;

    local SoundGroup = Instance.new("SoundGroup");
    SoundGroup.Name = "MegaphoneGroup";
    SoundGroup.Volume = 1;
    SoundGroup.Parent = SoundService;

    return SoundGroup;
end;

function v1.Init(p3) -- Line: 42
    -- upvalues: SFXGroup (copy), SFX_Volume (copy), GameMusic (copy), Music_Volume (copy), SoundService (copy), Settings (copy), TweenService (copy), u2 (copy)
    SFXGroup.Volume = SFX_Volume.Value;
    GameMusic.Volume = Music_Volume.Value;
    local MegaphoneGroup = SoundService:FindFirstChild("MegaphoneGroup");

    if not (MegaphoneGroup and MegaphoneGroup:IsA("SoundGroup")) then
        MegaphoneGroup = Instance.new("SoundGroup");
        MegaphoneGroup.Name = "MegaphoneGroup";
        MegaphoneGroup.Volume = 1;
        MegaphoneGroup.Parent = SoundService;
    end;

    game.DescendantAdded:Connect(function(p4) -- Line: 51, Name: routeMegaphone
        -- upvalues: MegaphoneGroup (copy)
        if p4.Name ~= "MegaphoneSound" and p4.Name ~= "BoomboxSound" then
            return;
        end;

        if p4:IsA("Sound") and p4.SoundGroup ~= MegaphoneGroup then
            p4.SoundGroup = MegaphoneGroup;
        end;
    end);

    for _, descendant in game:GetDescendants() do
        if descendant.Name == "MegaphoneSound" or descendant.Name == "BoomboxSound" then
            if descendant:IsA("Sound") and descendant.SoundGroup ~= MegaphoneGroup then
                descendant.SoundGroup = MegaphoneGroup;
            end;
        end;
    end;

    local Megaphone_Volume = Settings:WaitForChild("Megaphone_Volume", 10);

    if Megaphone_Volume and Megaphone_Volume:IsA("NumberValue") then
        MegaphoneGroup.Volume = Megaphone_Volume.Value;
        Megaphone_Volume:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 68
            -- upvalues: MegaphoneGroup (copy), Megaphone_Volume (copy)
            MegaphoneGroup.Volume = Megaphone_Volume.Value;
        end);
    end;

    local UnixTimestamp = DateTime.now().UnixTimestamp;
    SFX_Volume:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 74
        -- upvalues: SFXGroup (ref), SFX_Volume (ref)
        SFXGroup.Volume = SFX_Volume.Value;
    end);
    Music_Volume:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 77
        -- upvalues: UnixTimestamp (copy), TweenService (ref), GameMusic (ref), u2 (ref), Music_Volume (ref)
        if DateTime.now().UnixTimestamp - UnixTimestamp <= 3 then
            GameMusic.Volume = Music_Volume.Value;

            return;
        end;

        local v5 = TweenService:Create(GameMusic, u2, {
            Volume = Music_Volume.Value
        });
        v5:Play();
        game.Debris:AddItem(v5, u2.Time);
    end);
end;

local function SegmentHeightForSliders(p6) -- Line: 89
    local v7 = p6:FindFirstChildOfClass("UIListLayout");

    if not v7 then
        return nil;
    end;

    local Y = v7.AbsoluteContentSize.Y;

    if Y <= 0 then
        return nil;
    end;

    local Scale = p6.Size.Y.Scale;

    if Scale <= 0 then
        return nil;
    end;

    return math.ceil((Y - p6.Size.Y.Offset) / Scale);
end;

local function BindVolumeSegmentLayout() -- Line: 108
    -- upvalues: LocalPlayer (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 30);

    if PlayerGui then
        PlayerGui = PlayerGui:WaitForChild("Settings", 30);
    end;

    if PlayerGui then
        PlayerGui = PlayerGui:WaitForChild("Frame", 15);
    end;

    if PlayerGui then
        PlayerGui = PlayerGui:WaitForChild("Content", 15);
    end;

    if not (PlayerGui and PlayerGui:IsA("ScrollingFrame")) then
        return;
    end;

    PlayerGui.ClipsDescendants = true;
    PlayerGui.ScrollingDirection = Enum.ScrollingDirection.Y;
    local VolumeSegment = PlayerGui:WaitForChild("VolumeSegment", 15);
    local u8;

    if VolumeSegment then
        u8 = VolumeSegment:WaitForChild("Container", 15);
    else
        u8 = VolumeSegment;
    end;

    if not (VolumeSegment and u8) then
        return;
    end;

    local function Refresh() -- Line: 126
        -- upvalues: u8 (copy), VolumeSegment (copy)
        local v9 = u8;
        local v10 = v9:FindFirstChildOfClass("UIListLayout");
        local v11;

        if v10 then
            local Y = v10.AbsoluteContentSize.Y;

            if Y <= 0 then
                v11 = nil;
            else
                local Scale = v9.Size.Y.Scale;

                if Scale <= 0 then
                    v11 = nil;
                else
                    v11 = math.ceil((Y - v9.Size.Y.Offset) / Scale);
                end;
            end;
        else
            v11 = nil;
        end;

        if not v11 then
            return;
        end;

        local Size = VolumeSegment.Size;
        VolumeSegment.Size = UDim2.new(Size.X.Scale, Size.X.Offset, 0, v11);
    end;

    local v12 = u8:FindFirstChildOfClass("UIListLayout");
    local v13;

    if v12 then
        local Y = v12.AbsoluteContentSize.Y;

        if Y <= 0 then
            v13 = nil;
        else
            local Scale = u8.Size.Y.Scale;

            if Scale <= 0 then
                v13 = nil;
            else
                v13 = math.ceil((Y - u8.Size.Y.Offset) / Scale);
            end;
        end;
    else
        v13 = nil;
    end;

    if v13 then
        local Size = VolumeSegment.Size;
        VolumeSegment.Size = UDim2.new(Size.X.Scale, Size.X.Offset, 0, v13);
    end;

    local v14 = u8:FindFirstChildOfClass("UIListLayout");

    if v14 then
        v14:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Refresh);
    end;
end;

function v1.Start(p15) -- Line: 143
    -- upvalues: BindVolumeSegmentLayout (copy)
    task.spawn(BindVolumeSegmentLayout);
end;

return v1;