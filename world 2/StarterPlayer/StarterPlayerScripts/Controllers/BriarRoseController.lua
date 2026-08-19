-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local LocalPlayer = Players.LocalPlayer;
local Sound = Instance.new("Sound");
Sound.Name = "BriarRoseSFX";
Sound.SoundId = "rbxassetid://81871118463376";
Sound.Parent = SoundService;
local u1 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u2 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u3 = {
    Connections = {}
};
local u4 = 0;
local u5 = false;
local u6 = nil;

local function GetFxImage() -- Line: 30
    -- upvalues: LocalPlayer (copy)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if PlayerGui then
        PlayerGui = PlayerGui:FindFirstChild("RadialScreenFlash");
    end;

    if PlayerGui then
        PlayerGui = PlayerGui:FindFirstChild("BriarRose");
    end;

    if PlayerGui and PlayerGui:IsA("ImageLabel") then
        return PlayerGui;
    end;

    return nil;
end;

local function TweenFx(p7, p8) -- Line: 40
    -- upvalues: LocalPlayer (copy), u6 (ref), TweenService (copy)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if PlayerGui then
        PlayerGui = PlayerGui:FindFirstChild("RadialScreenFlash");
    end;

    if PlayerGui then
        PlayerGui = PlayerGui:FindFirstChild("BriarRose");
    end;

    if not (PlayerGui and PlayerGui:IsA("ImageLabel")) then
        PlayerGui = nil;
    end;

    if not PlayerGui then
        return;
    end;

    if u6 then
        u6:Cancel();
        u6 = nil;
    end;

    local v9 = TweenService:Create(PlayerGui, p8, {
        ImageTransparency = p7
    });
    u6 = v9;
    v9:Play();
end;

local function AddHighlight(p10) -- Line: 52
    for _, child in p10:GetChildren() do
        if child:IsA("Highlight") and child:GetAttribute("BriarRoseHighlight") then
            return;
        end;
    end;

    local Highlight = Instance.new("Highlight");
    Highlight.FillColor = Color3.fromRGB(120, 30, 200);
    Highlight.FillTransparency = 0.5;
    Highlight.OutlineTransparency = 0.9967;
    Highlight:SetAttribute("BriarRoseHighlight", true);
    Highlight.Adornee = p10;
    Highlight.Parent = p10;
end;

local function RemoveHighlight(p11) -- Line: 67
    for _, child in p11:GetChildren() do
        if child:IsA("Highlight") and child:GetAttribute("BriarRoseHighlight") then
            child:Destroy();
        end;
    end;
end;

function u3.RegisterPart(p12, p13) -- Line: 75
    -- upvalues: LocalPlayer (copy), u4 (ref), Sound (copy), Networking (copy)
    if p12.Connections[p13] then
        return;
    end;

    p12.Connections[p13] = p13.Touched:Connect(function(p14) -- Line: 78
        -- upvalues: LocalPlayer (ref), u4 (ref), Sound (ref), Networking (ref)
        local Character = LocalPlayer.Character;

        if not Character then
            return;
        end;

        if not p14:IsDescendantOf(Character) then
            return;
        end;

        if LocalPlayer:GetAttribute("IsInOwnGarden") ~= true then
            return;
        end;

        if workspace:GetServerTimeNow() - u4 < 0.4 then
            return;
        end;

        u4 = workspace:GetServerTimeNow();
        Sound.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        Sound.TimePosition = 0;
        Sound.Playing = true;
        Networking.BriarRose.Touched:Fire();
    end);
end;

function u3.UnregisterPart(p15, p16) -- Line: 97
    if p15.Connections[p16] then
        p15.Connections[p16]:Disconnect();
        p15.Connections[p16] = nil;
    end;
end;

function u3.SetInvisible(p17, p18) -- Line: 104
    -- upvalues: u5 (ref), LocalPlayer (copy), TweenFx (copy), u1 (copy), AddHighlight (copy), u2 (copy), RemoveHighlight (copy)
    if p18 == u5 then
        return;
    end;

    u5 = p18;
    local Character = LocalPlayer.Character;

    if p18 then
        TweenFx(0, u1);

        if Character then
            AddHighlight(Character);
        end;
    else
        TweenFx(1, u2);

        if Character then
            RemoveHighlight(Character);
        end;
    end;
end;

function u3.Init(p19) -- Line: 123
    -- upvalues: Networking (copy), u3 (copy)
    Networking.BriarRose.SetInvisible.OnClientEvent:Connect(function(p20) -- Line: 124
        -- upvalues: u3 (ref)
        u3:SetInvisible(p20);
    end);
end;

function u3.Start(u21) -- Line: 129
    -- upvalues: CollectionService (copy)
    for _, v in CollectionService:GetTagged("BriarRose") do
        u21:RegisterPart(v);
    end;

    CollectionService:GetInstanceAddedSignal("BriarRose"):Connect(function(p22) -- Line: 134
        -- upvalues: u21 (copy)
        u21:RegisterPart(p22);
    end);
    CollectionService:GetInstanceRemovedSignal("BriarRose"):Connect(function(p23) -- Line: 138
        -- upvalues: u21 (copy)
        u21:UnregisterPart(p23);
    end);
end;

return u3;