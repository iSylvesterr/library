-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Library = game:GetService("ReplicatedStorage").Library;
local UIOffsetScaler = require(Library.Functions.UIOffsetScaler);
local Client = Library.Client;
local Settings = require(Client.Settings);
local FFlags = require(Client.FFlags);
local ScreenResolution = require(Client.ScreenResolution);
local InstanceChangeQueue = require(Library.Modules.InstanceChangeQueue);
local u1 = {};
local u2 = {};
local u3 = false;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u9 = InstanceChangeQueue.new({
    MaxInstancesPerStep = 128,
    MaxStepTime = 0.0025,
    StepInterval = 0.016666666666666666,

    OnAdded = function(p8) -- Line: 46, Name: OnAdded
        -- upvalues: u5 (ref)
        u5(p8);
    end
});
local u12 = InstanceChangeQueue.new({
    MaxInstancesPerStep = 128,
    MaxStepTime = 0.0025,
    StepInterval = 0.016666666666666666,

    Filter = function(p10) -- Line: 54, Name: Filter
        -- upvalues: u6 (ref)
        return u6(p10);
    end,

    OnAdded = function(p11) -- Line: 57, Name: OnAdded
        -- upvalues: u4 (ref)
        u4.Track(p11);
    end
});

u6 = function(p13) -- Line: 66
    return p13:IsA("BillboardGui") or p13:IsA("SurfaceGui");
end;

u5 = function(p14) -- Line: 70
    -- upvalues: u4 (ref), Settings (copy)
    debug.profilebegin("InterfaceScaling :: QueueApplyScaling");
    u4.ApplyScaling(p14);

    if Settings.ScaleRichText and p14:IsA("TextLabel") then
        u4.TrackRichText(p14);
    end;

    debug.profileend();
end;

u4 = {
    ResolutionRatioMultiplier = 0.5,
    ScreenGuiIgnoreList = { "Chat", "TouchGui" },
    UIOffsetScaler = UIOffsetScaler({
        Stroke = Settings.ScaleStrokes,
        RichText = Settings.ScaleRichText,
        NineSlice = Settings.Scale9Slice,
        Padding = Settings.ScalePadding,
        List = Settings.ScaleLists,
        Grid = Settings.ScaleGrids,
        ScrollBar = Settings.ScaleScrollbars
    }),

    ComputeScale = function() -- Line: 93, Name: ComputeScale
        -- upvalues: ScreenResolution (copy), u4 (ref)
        return 1 - (1 - ScreenResolution.GetScale()) * u4.ResolutionRatioMultiplier;
    end,

    ApplyScaling = function(p15, p16) -- Line: 96, Name: ApplyScaling
        -- upvalues: FFlags (copy), u4 (ref)
        debug.profilebegin("InterfaceScaling :: ApplyScaling");

        if FFlags.Get(FFlags.Keys.InterfaceScaling) then
            u4.UIOffsetScaler(p15, u4.ComputeScale(), p16);
        end;

        debug.profileend();
    end,

    TrackRichText = function(u17) -- Line: 103, Name: TrackRichText
        -- upvalues: u2 (copy), u4 (ref)
        if u2[u17] or not u17:IsA("TextLabel") then
            return;
        end;

        u2[u17] = true;
        u17.Destroying:Connect(function() -- Line: 109
            -- upvalues: u2 (ref), u17 (copy)
            u2[u17] = nil;
        end);
        u17:GetAttributeChangedSignal("Text"):Connect(function() -- Line: 113
            -- upvalues: u4 (ref), u17 (copy)
            u4.ApplyScaling(u17);
        end);
    end,

    Track = function(u18) -- Line: 117, Name: Track
        -- upvalues: u1 (copy), u4 (ref), Settings (copy), u9 (copy)
        debug.profilebegin("InterfaceScaling :: Track");

        if u1[u18] or not u18.Parent then
            debug.profileend();

            return;
        end;

        u1[u18] = true;
        u18.Destroying:Connect(function() -- Line: 125
            -- upvalues: u1 (ref), u18 (copy)
            u1[u18] = nil;
        end);
        u4.ApplyScaling(u18);

        if Settings.ScaleRichText and u18:IsA("TextLabel") then
            u4.TrackRichText(u18);
        end;

        u9:QueueDescendantsAdded(u18, false);
        u18.DescendantAdded:Connect(function(p19) -- Line: 137
            -- upvalues: u9 (ref)
            u9:QueueAdded(p19);
        end);
        debug.profileend();
    end,

    ApplyScalingAll = function() -- Line: 143, Name: ApplyScalingAll
        -- upvalues: u1 (copy), u4 (ref)
        debug.profilebegin("InterfaceScaling :: ApplyScalingAll");

        for i in u1 do
            u4.ApplyScaling(i);
        end;

        debug.profileend();
    end,

    WorldRootTrack = function(...) -- Line: 150, Name: WorldRootTrack
        -- upvalues: u12 (copy), u6 (ref), u4 (ref)
        debug.profilebegin("InterfaceScaling :: WorldRootTrack");

        for _, v in ipairs(table.pack(...)) do
            u12:QueueDescendantsAdded(v, false);
            v.DescendantAdded:Connect(function(p20) -- Line: 155
                -- upvalues: u6 (ref), u4 (ref)
                if u6(p20) then
                    u4.Track(p20);
                end;
            end);
        end;

        debug.profileend();
    end,

    DeepCheckScreenGui = function(p21) -- Line: 163, Name: DeepCheckScreenGui
        -- upvalues: u7 (ref)
        u7(p21);
    end
};

u7 = function(p22) -- Line: 168
    -- upvalues: u7 (ref), u4 (ref)
    debug.profilebegin("InterfaceScaling :: DeepCheckScreenGui");

    if p22:IsA("Folder") then
        for _, child in ipairs(p22:GetChildren()) do
            u7(child);
        end;

        debug.profileend();

        return;
    end;

    if p22:IsA("ScreenGui") and not table.find(u4.ScreenGuiIgnoreList, p22.Name) then
        u4.Track(p22);
    end;

    debug.profileend();
end;

task.spawn(function() -- Line: 185
    -- upvalues: Players (copy), u4 (ref)
    local PlayerGui = Players.LocalPlayer.PlayerGui;

    for _, child in ipairs(PlayerGui:GetChildren()) do
        u4.DeepCheckScreenGui(child);
    end;

    PlayerGui.ChildAdded:Connect(function(p23) -- Line: 190
        -- upvalues: u4 (ref)
        u4.DeepCheckScreenGui(p23);
    end);
end);
ScreenResolution.Changed:Connect(function() -- Line: 195
    -- upvalues: u3 (ref)
    u3 = true;
end);
RunService.RenderStepped:Connect(function() -- Line: 199
    -- upvalues: u3 (ref), u4 (ref)
    if not u3 then
        return;
    end;

    u3 = false;
    u4.ApplyScalingAll();
end);

return u4;