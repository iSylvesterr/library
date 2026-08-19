-- Decompiled with Potassium's decompiler.

local u1 = {};
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local LocalPlayer = Players.LocalPlayer;
local u2 = RaycastParams.new();
u2.FilterType = Enum.RaycastFilterType.Exclude;
u2.IgnoreWater = true;
local u3 = 0;
local u4 = -1;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = 0;
local u9 = nil;
RunServiceController.BindToHeartbeat("Components.CenterScreenRaycast.InvalidateCache", function() -- Line: 35
    -- upvalues: u3 (ref)
    u3 = u3 + 1;
end);

local function ClearCache() -- Line: 39
    -- upvalues: u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
    u4 = -1;
    u5 = nil;
    u6 = nil;
    u7 = nil;
    u8 = 0;
    u9 = nil;
end;

local function ResolveRaycast(p10) -- Line: 48
    -- upvalues: Workspace (copy), LocalPlayer (copy), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u3 (ref), u2 (copy)
    local CurrentCamera = Workspace.CurrentCamera;
    local Character = LocalPlayer.Character;

    if not (CurrentCamera and Character) then
        u4 = -1;
        u5 = nil;
        u6 = nil;
        u7 = nil;
        u8 = 0;
        u9 = nil;

        return nil;
    end;

    local CFrame = CurrentCamera.CFrame;
    local v11;

    if u4 == u3 and (u5 == CurrentCamera and (u7 == Character and u6 == CFrame)) then
        v11 = p10 <= u8;
    else
        v11 = false;
    end;

    if v11 then
        return u9;
    end;

    u2.FilterDescendantsInstances = { Character, CurrentCamera };
    u9 = Workspace:Raycast(CFrame.Position, CFrame.LookVector * p10, u2);
    u4 = u3;
    u5 = CurrentCamera;
    u6 = CFrame;
    u7 = Character;
    u8 = p10;

    return u9;
end;

local function FindAncestor(p12, p13) -- Line: 76
    while p12 do
        if p13(p12) then
            return p12;
        end;

        p12 = p12.Parent;
    end;

    return nil;
end;

function u1.GetResult(p14) -- Line: 87
    -- upvalues: ResolveRaycast (copy)
    local v15 = p14 or 10;
    local v16 = ResolveRaycast(v15);

    if not v16 then
        return nil;
    end;

    if v15 < v16.Distance then
        return nil;
    end;

    return v16;
end;

function u1.GetInstance(p17) -- Line: 99
    -- upvalues: u1 (copy)
    local v18 = u1.GetResult(p17);

    if v18 then
        return v18.Instance;
    end;

    return nil;
end;

function u1.FindAncestor(p19, p20) -- Line: 104
    -- upvalues: u1 (copy)
    local v21 = u1.GetResult(p20);

    if not v21 then
        return nil;
    end;

    local Instance = v21.Instance;

    while Instance do
        if p19(Instance) then
            return Instance;
        end;

        Instance = Instance.Parent;
    end;

    return nil;
end;

function u1.FindTaggedAncestor(u22, p23) -- Line: 112
    -- upvalues: u1 (copy), CollectionService (copy)
    return u1.FindAncestor(function(p24) -- Line: 113
        -- upvalues: CollectionService (ref), u22 (copy)
        return CollectionService:HasTag(p24, u22);
    end, p23);
end;

function u1.GetHoveredHostage(p25) -- Line: 118
    -- upvalues: LocalPlayer (copy), u1 (copy)
    if LocalPlayer:GetAttribute("Team") ~= "Counter-Terrorists" then
        return nil;
    end;

    local v26 = u1.FindTaggedAncestor("Hostage", p25 or 5);

    if not (v26 and v26:IsA("Model")) then
        return nil;
    end;

    if v26:GetAttribute("CanRescue") ~= true then
        return nil;
    end;

    local v27 = v26:GetAttribute("RescuingPlayer");

    if v27 and v27 ~= LocalPlayer.Name then
        return nil;
    end;

    if v26:GetAttribute("CarryingPlayer") then
        return nil;
    end;

    return v26;
end;

function u1.Invalidate() -- Line: 143
    -- upvalues: u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
    u4 = -1;
    u5 = nil;
    u6 = nil;
    u7 = nil;
    u8 = 0;
    u9 = nil;
end;

return u1;