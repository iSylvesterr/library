-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local ScreenResolution = require(script.Parent.Parent.ScreenResolution);
local Signal = require(script.Parent.Parent.Signal);
local u1 = table.freeze({
    Color3.fromRGB(255, 92, 116),
    Color3.fromRGB(255, 176, 59),
    Color3.fromRGB(255, 233, 87),
    Color3.fromRGB(112, 224, 122),
    Color3.fromRGB(85, 183, 255),
    Color3.fromRGB(178, 122, 255),
    Color3.fromRGB(255, 255, 255)
});
local u2 = NumberRange.new(2, 3.5);
local u3 = NumberRange.new(8, 15);
local u4 = NumberRange.new(0.01, 0.08);
local u5 = NumberRange.new(0.2, 1.4);
local u6 = NumberRange.new(0.45, 1.4);
local u7 = NumberRange.new(0.4, 1.2);
local u8 = NumberRange.new(2, 6);
local u9 = NumberRange.new(-0.2, -0.02);
local u10 = NumberRange.new(-0.05, 1.05);

local function AssertNumberRange(p11) -- Line: 101
    if typeof(p11) ~= "NumberRange" then
        error("NumberRange", 2);
    end;

    return p11;
end;

local function GetHolder(p12) -- Line: 108
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;

    if LocalPlayer then
        LocalPlayer = LocalPlayer:FindFirstChildOfClass("PlayerGui");
    end;

    if not LocalPlayer then
        return nil;
    end;

    local ScreenConfettiGui = LocalPlayer:FindFirstChild("ScreenConfettiGui");

    if ScreenConfettiGui and ScreenConfettiGui:IsA("ScreenGui") then
        ScreenConfettiGui.DisplayOrder = p12;

        return ScreenConfettiGui;
    end;

    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "ScreenConfettiGui";
    ScreenGui.DisplayOrder = p12;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.Parent = LocalPlayer;

    return ScreenGui;
end;

local function Finish(p13) -- Line: 131
    if p13.Done then
        return;
    end;

    p13.Done = true;
    p13.Spawning = false;
    local Connection = p13.Connection;

    if Connection then
        Connection:Disconnect();
        p13.Connection = nil;
    end;

    p13.Container:Destroy();
    table.clear(p13.Pieces);
    p13.Completed:Fire();
end;

local function SpawnPiece(p14) -- Line: 149
    -- upvalues: u6 (copy), u10 (copy), u9 (copy), u7 (copy), u8 (copy)
    local Random2 = p14.Random;
    local v15 = Random2:NextNumber(p14.Size.Min, p14.Size.Max) * p14.Scale;
    local v16 = v15 * Random2:NextNumber(u6.Min, u6.Max);
    local v17 = Random2:NextNumber(p14.FallTime.Min, p14.FallTime.Max);
    local v18 = math.max(v17, 0.05);
    local v19 = {
        Frame = Instance.new("Frame"),
        X = Random2:NextNumber(u10.Min, u10.Max),
        Y = Random2:NextNumber(u9.Min, u9.Max),
        FallSpeed = 1 / v18,
        SwayAmount = Random2:NextNumber(p14.Sway.Min, p14.Sway.Max),
        SwayPhase = Random2:NextNumber(0, 6.283185307179586),
        SwaySpeed = Random2:NextNumber(u7.Min, u7.Max) * 3.141592653589793 * 2,
        Spin = Random2:NextNumber(0, 360),
        SpinSpeed = Random2:NextNumber(p14.SpinSpeed.Min, p14.SpinSpeed.Max) * 360 * (Random2:NextNumber() < 0.5 and -1 or 1),
        Flip = Random2:NextNumber(0, 6.283185307179586),
        FlipSpeed = Random2:NextNumber(u8.Min, u8.Max),
        Width = v15,
        Height = v16
    };
    local Frame = v19.Frame;
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundColor3 = p14.Colors[Random2:NextInteger(1, #p14.Colors)];
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(v19.X, v19.Y);
    Frame.Rotation = v19.Spin;
    Frame.Size = UDim2.fromOffset(v15, v16);
    Frame.Parent = p14.Container;
    table.insert(p14.Pieces, v19);
end;

local function Update(p20, p21) -- Line: 185
    -- upvalues: SpawnPiece (copy)
    local Pieces = p20.Pieces;

    if p20.Spawning then
        p20.Remaining = p20.Remaining - p21;
        p20.Backlog = p20.Backlog + p20.Rate * p21;

        while p20.Backlog >= 1 do
            p20.Backlog = p20.Backlog - 1;

            if #Pieces < p20.MaxPieces then
                SpawnPiece(p20);
            end;
        end;

        if p20.Remaining <= 0 then
            p20.Spawning = false;
        end;
    end;

    for i = #Pieces, 1, -1 do
        local v22 = Pieces[i];
        v22.Y = v22.Y + v22.FallSpeed * p21;

        if v22.Y > 1.15 then
            v22.Frame:Destroy();
            Pieces[i] = Pieces[#Pieces];
            table.remove(Pieces);
        else
            v22.SwayPhase = v22.SwayPhase + v22.SwaySpeed * p21;
            v22.X = v22.X + math.sin(v22.SwayPhase) * v22.SwayAmount * p21;
            v22.Spin = v22.Spin + v22.SpinSpeed * p21;
            v22.Flip = v22.Flip + v22.FlipSpeed * p21;
            local Frame = v22.Frame;
            Frame.Position = UDim2.fromScale(v22.X, v22.Y);
            Frame.Rotation = v22.Spin;
            local fromOffset = UDim2.fromOffset;
            local Width = v22.Width;
            local v23 = math.cos(v22.Flip);
            local v24 = Width * math.abs(v23);
            Frame.Size = fromOffset(math.max(v24, 1), v22.Height);
        end;
    end;

    if not p20.Spawning and #Pieces == 0 then
        if p20.Done then
            return;
        end;

        p20.Done = true;
        p20.Spawning = false;
        local Connection = p20.Connection;

        if Connection then
            Connection:Disconnect();
            p20.Connection = nil;
        end;

        p20.Container:Destroy();
        table.clear(p20.Pieces);
        p20.Completed:Fire();
    end;
end;

local v30 = table.freeze({
    Stop = function(p25) -- Line: 229, Name: Stop
        p25.Spawning = false;
        p25.Remaining = 0;
    end,

    Cancel = function(p26) -- Line: 234, Name: Cancel
        if p26.Done then
            return;
        end;

        p26.Done = true;
        p26.Spawning = false;
        local Connection = p26.Connection;

        if Connection then
            Connection:Disconnect();
            p26.Connection = nil;
        end;

        p26.Container:Destroy();
        table.clear(p26.Pieces);
        p26.Completed:Fire();
    end,

    Wait = function(p27) -- Line: 238, Name: Wait
        if p27.Done then
            return;
        end;

        p27.Completed:Wait();
    end,

    IsSpawning = function(p28) -- Line: 245, Name: IsSpawning
        return p28.Spawning;
    end,

    IsActive = function(p29) -- Line: 249, Name: IsActive
        return not p29.Done;
    end
});
local u31 = table.freeze({
    __index = v30
});
local u33 = Asserts.Table({
    Duration = Asserts.Optional(Asserts.FiniteNonNegative),
    Rate = Asserts.Optional(Asserts.FiniteNonNegative),
    Burst = Asserts.Optional(Asserts.IntegerNonNegative),
    Colors = Asserts.Optional(Asserts.Array(function(p32) -- Line: 94, Name: AssertColor3
        if typeof(p32) ~= "Color3" then
            error("Color3", 2);
        end;

        return p32;
    end)),
    FallTime = Asserts.Optional(AssertNumberRange),
    Size = Asserts.Optional(AssertNumberRange),
    Sway = Asserts.Optional(AssertNumberRange),
    SpinSpeed = Asserts.Optional(AssertNumberRange),
    MaxPieces = Asserts.Optional(Asserts.IntegerPositive),
    DisplayOrder = Asserts.Optional(Asserts.Integer)
});
local v46 = {
    Play = function(p34) -- Line: 310, Name: Play
        -- upvalues: u33 (copy), u1 (copy), Signal (copy), u2 (copy), u3 (copy), u4 (copy), u5 (copy), ScreenResolution (copy), u31 (copy), GetHolder (copy), SpawnPiece (copy), RunService (copy), Update (copy)
        local v35 = p34 or {};
        u33(v35);
        local Colors = v35.Colors;

        if not Colors or #Colors == 0 then
            Colors = u1;
        end;

        local v36 = v35.Duration or 3;
        local v37 = v35.Burst or 0;
        local Frame = Instance.new("Frame");
        Frame.Name = "Confetti";
        Frame.BackgroundTransparency = 1;
        Frame.BorderSizePixel = 0;
        Frame.Size = UDim2.fromScale(1, 1);
        local v38 = {
            Backlog = 0,
            Done = false,
            Completed = Signal.new(),
            Container = Frame,
            Pieces = {},
            Random = Random.new(),
            Colors = Colors,
            Rate = v35.Rate or 90,
            MaxPieces = v35.MaxPieces or 400,
            FallTime = v35.FallTime or u2,
            Size = v35.Size or u3,
            Sway = v35.Sway or u4,
            SpinSpeed = v35.SpinSpeed or u5,
            Scale = ScreenResolution.GetResolutionScale(),
            Remaining = v36,
            Spawning = v36 > 0
        };
        local u39 = setmetatable(v38, u31);
        local v40 = GetHolder(v35.DisplayOrder or 1000);

        if v40 then
            Frame.Parent = v40;

            for _ = 1, math.min(v37, u39.MaxPieces) do
                SpawnPiece(u39);
            end;

            u39.Connection = RunService.RenderStepped:Connect(function(p41) -- Line: 359
                -- upvalues: Update (ref), u39 (copy)
                Update(u39, p41);
            end);

            return u39;
        end;

        if u39.Done then
            return u39;
        end;

        u39.Done = true;
        u39.Spawning = false;
        local Connection = u39.Connection;

        if Connection then
            Connection:Disconnect();
            u39.Connection = nil;
        end;

        u39.Container:Destroy();
        table.clear(u39.Pieces);
        u39.Completed:Fire();

        return u39;
    end,

    GrandPrizeParams = table.freeze({
        Duration = 5,
        Size = NumberRange.new(16, 30)
    }),

    IsA = function(p42) -- Line: 263, Name: IsA
        -- upvalues: u31 (copy)
        local v43;

        if type(p42) == "table" then
            v43 = getmetatable(p42) == u31;
        else
            v43 = false;
        end;

        return v43;
    end,

    Assert = function(p44) -- Line: 267, Name: Assert
        -- upvalues: u31 (copy)
        local v45;

        if type(p44) == "table" then
            v45 = getmetatable(p44) == u31;
        else
            v45 = false;
        end;

        if not v45 then
            error("ScreenConfetti", 2);
        end;

        return p44;
    end
};

return table.freeze(v46);