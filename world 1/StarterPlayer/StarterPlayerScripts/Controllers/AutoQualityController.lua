-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Stats = game:GetService("Stats");
local UserInputService = game:GetService("UserInputService");
local ABTests = require(ReplicatedStorage.UserGenerated.ABTests);
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local PerfFlags = require(ReplicatedStorage.SharedModules.Flags.PerfFlags);
local LocalPlayer = Players.LocalPlayer;
local u1 = table.freeze({ table.freeze({
        Name = "Low",
        CullRange = 250,
        AgeMaxHz = 5,
        PlantBudget = 30
    }), table.freeze({
        Name = "Medium",
        CullRange = 400,
        AgeMaxHz = 10,
        PlantBudget = 60
    }), table.freeze({
        Name = "High",
        CullRange = 0,
        AgeMaxHz = 0,
        PlantBudget = 0
    }) });
local u2 = #u1;
local u3 = table.freeze({ 30, 60, 75, 90, 120, 144, 165, 240 });
local u4 = false;
local u5 = {};
local u6 = 0;
local u7 = false;
local u8 = true;
local u9 = os.clock();
local u10 = u2;
local u11 = 0;
local u12 = 0;
local u13 = (-1 / 0);
local u14 = 60;
local u15 = 0;
local u16 = false;
local u17 = nil;

local function Percentile(p18, p19) -- Line: 97
    local v20 = #p18;

    if v20 == 0 then
        return 0;
    end;

    local v21 = math.ceil(p19 * v20);

    return p18[math.clamp(v21, 1, v20)];
end;

local function SnapFpsCap(p22) -- Line: 106
    -- upvalues: u3 (copy)
    for _, v in u3 do
        if math.abs(p22 - v) / v <= 0.12 then
            return v;
        end;
    end;

    return p22;
end;

local function CountPlantLoad() -- Line: 117
    -- upvalues: ReplicatedStorage (copy)
    local v23 = 0;
    local Gardens = workspace:FindFirstChild("Gardens");

    if Gardens then
        for _, child in Gardens:GetChildren() do
            local Plants = child:FindFirstChild("Plants");

            if Plants then
                v23 = v23 + #Plants:GetChildren();
            end;
        end;
    end;

    local CulledPlants = ReplicatedStorage:FindFirstChild("CulledPlants");

    if CulledPlants then
        v23 = v23 + #CulledPlants:GetChildren();
    end;

    return v23;
end;

local function GetTotalMemoryMb() -- Line: 135
    -- upvalues: Stats (copy)
    local success, result = pcall(function() -- Line: 136
        -- upvalues: Stats (ref)
        return Stats:GetTotalMemoryUsageMb();
    end);

    return (not success or type(result) ~= "number") and 0 or result;
end;

local function ApplyBucket(p24) -- Line: 145
    -- upvalues: u1 (copy), LocalPlayer (copy)
    local v25 = u1[p24];
    LocalPlayer:SetAttribute("AutoQualityBucket", v25.Name);
    LocalPlayer:SetAttribute("AutoQualityCullRange", v25.CullRange);
    LocalPlayer:SetAttribute("AutoQualityAgeMaxHz", v25.AgeMaxHz);
    LocalPlayer:SetAttribute("AutoQualityPlantBudget", v25.PlantBudget);
end;

local function ReportChange(p26, p27, p28) -- Line: 153
    -- upvalues: Networking (copy), u1 (copy), u10 (ref), u14 (ref), CountPlantLoad (copy), Lighting (copy), UserInputService (copy), Stats (copy)
    local v29;

    if workspace.CurrentCamera then
        v29 = workspace.CurrentCamera.ViewportSize;
    else
        v29 = Vector2.zero;
    end;

    local ReportAutoQuality = Networking.Settings.ReportAutoQuality;
    local v30 = {
        Bucket = u1[u10].Name,
        PreviousBucket = u1[p27].Name,
        Reason = p26,
        FrameP90Ms = p28,
        FpsCap = u14,
        PlantLoad = CountPlantLoad(),
        ActiveEffects = tonumber(Lighting:GetAttribute("ActiveWeatherEffects")) or 0,
        ViewportX = v29.X,
        ViewportY = v29.Y,
        Touch = UserInputService.TouchEnabled
    };
    local success, result = pcall(function() -- Line: 136
        -- upvalues: Stats (ref)
        return Stats:GetTotalMemoryUsageMb();
    end);
    v30.MemoryMb = (not success or type(result) ~= "number") and 0 or result;
    ReportAutoQuality:Fire(v30);
end;

local function ResetWindow() -- Line: 170
    -- upvalues: u5 (copy), u6 (ref), u7 (ref)
    table.clear(u5);
    u6 = 0;
    u7 = false;
end;

local function IsSamplingValid() -- Line: 176
    -- upvalues: u4 (ref), u8 (ref), u9 (copy), LocalPlayer (copy), u17 (ref)
    if not u4 then
        return false;
    end;

    if not u8 then
        return false;
    end;

    if os.clock() - u9 < 30 then
        return false;
    end;

    if LocalPlayer:GetAttribute("LoadingScreenActive") == true then
        return false;
    end;

    return not (u17 and u17:GetOfflineCutsceneState());
end;

local function EvaluateWindow() -- Line: 195
    -- upvalues: u5 (copy), u14 (ref), u3 (copy), PerfFlags (copy), u16 (ref), ReportChange (copy), u10 (ref), u12 (ref), u11 (ref), u13 (ref), u15 (ref), CountPlantLoad (copy), u1 (copy), LocalPlayer (copy), u2 (copy)
    table.sort(u5);
    local v31 = u5;
    local v32 = #v31;
    local v33;

    if v32 == 0 then
        v33 = 0;
    else
        local v34 = math.ceil(v32 * 0.9);
        v33 = v31[math.clamp(v34, 1, v32)];
    end;

    local v35 = u5;
    local v36 = #v35;
    local v37;

    if v36 == 0 then
        v37 = 0;
    else
        local v38 = math.ceil(v36 * 0.1);
        v37 = v35[math.clamp(v38, 1, v36)];
    end;

    if v33 <= 0 or v37 <= 0 then
        return;
    end;

    local v39 = 1 / v37;

    for _, v in u3 do
        if math.abs(v39 - v) / v <= 0.12 then
            v39 = v;
            break;
        end;
    end;

    u14 = math.max(u14, v39);
    local v40 = 1 / v33;
    local v41 = u14 * PerfFlags.AutoQualityBadFpsFraction:Get();
    local v42 = u14 * PerfFlags.AutoQualityGoodFpsFraction:Get();
    local v43 = v33 * 1000;

    if not u16 then
        u16 = true;
        ReportChange("Initial", u10, v43);
    end;

    if v40 < v41 then
        u12 = u12 + 1;
        u11 = 0;
    elseif v42 < v40 then
        u11 = u11 + 1;
        u12 = 0;
    else
        u12 = 0;
    end;

    local v44 = os.clock();
    local v45 = v44 - u13 >= PerfFlags.AutoQualityMinDwellSeconds:Get();

    if u10 <= 1 or (not v45 or u12 < PerfFlags.AutoQualityDemoteWindows:Get()) then
        if u10 < u2 and v45 then
            local v46 = PerfFlags.AutoQualityPromoteWindows:Get();
            local v47 = CountPlantLoad() >= u15 * 0.7 and true or u11 >= v46 * 2;

            if v46 <= u11 and v47 then
                local v48 = u10;
                u10 = u10 + 1;
                u12 = 0;
                u11 = 0;
                u13 = v44;
                local v49 = u1[u10];
                LocalPlayer:SetAttribute("AutoQualityBucket", v49.Name);
                LocalPlayer:SetAttribute("AutoQualityCullRange", v49.CullRange);
                LocalPlayer:SetAttribute("AutoQualityAgeMaxHz", v49.AgeMaxHz);
                LocalPlayer:SetAttribute("AutoQualityPlantBudget", v49.PlantBudget);
                ReportChange("Promote", v48, v43);
            end;
        end;

        return;
    end;

    local v50 = u10;
    u10 = u10 - 1;
    u12 = 0;
    u11 = 0;
    u13 = v44;
    u15 = CountPlantLoad();
    local v51 = u1[u10];
    LocalPlayer:SetAttribute("AutoQualityBucket", v51.Name);
    LocalPlayer:SetAttribute("AutoQualityCullRange", v51.CullRange);
    LocalPlayer:SetAttribute("AutoQualityAgeMaxHz", v51.AgeMaxHz);
    LocalPlayer:SetAttribute("AutoQualityPlantBudget", v51.PlantBudget);
    ReportChange("Demote", v50, v43);
end;

local function InitialBucketIndex() -- Line: 264
    -- upvalues: UserInputService (copy), u2 (copy)
    local v52;

    if workspace.CurrentCamera then
        v52 = workspace.CurrentCamera.ViewportSize;
    else
        v52 = Vector2.zero;
    end;

    local v53;

    if math.min(v52.X, v52.Y) > 0 then
        v53 = math.min(v52.X, v52.Y) < 750;
    else
        v53 = false;
    end;

    if UserInputService.TouchEnabled and (not UserInputService.KeyboardEnabled and v53) then
        return u2 - 1;
    end;

    return u2;
end;

local function ResolveEnabled() -- Line: 276
    -- upvalues: PerfFlags (copy), ABTests (copy), LocalPlayer (copy)
    if not PerfFlags.AutoQualityEnabled:Get() then
        return false;
    end;

    local v54 = ABTests.GetAttribute(LocalPlayer, "Perf.AutoQuality.Enabled", false);

    if type(v54) ~= "boolean" then
        v54 = false;
    end;

    return v54;
end;

local function SetEnabled(p55) -- Line: 287
    -- upvalues: u4 (ref), LocalPlayer (copy), u10 (ref), UserInputService (copy), u2 (copy), u11 (ref), u12 (ref), u13 (ref), u15 (ref), u16 (ref), u5 (copy), u6 (ref), u7 (ref), u1 (copy), ReportChange (copy)
    if u4 == p55 then
        return;
    end;

    u4 = p55;
    LocalPlayer:SetAttribute("AutoQualityActive", p55);

    if not p55 then
        local v56 = u10;
        u10 = u2;
        local v57 = u1[u2];
        LocalPlayer:SetAttribute("AutoQualityBucket", v57.Name);
        LocalPlayer:SetAttribute("AutoQualityCullRange", v57.CullRange);
        LocalPlayer:SetAttribute("AutoQualityAgeMaxHz", v57.AgeMaxHz);
        LocalPlayer:SetAttribute("AutoQualityPlantBudget", v57.PlantBudget);
        table.clear(u5);
        u6 = 0;
        u7 = false;

        if v56 ~= u2 then
            ReportChange("Disabled", v56, 0);
        end;

        return;
    end;

    local v58;

    if workspace.CurrentCamera then
        v58 = workspace.CurrentCamera.ViewportSize;
    else
        v58 = Vector2.zero;
    end;

    local v59;

    if math.min(v58.X, v58.Y) > 0 then
        v59 = math.min(v58.X, v58.Y) < 750;
    else
        v59 = false;
    end;

    local v60;

    if UserInputService.TouchEnabled and (not UserInputService.KeyboardEnabled and v59) then
        v60 = u2 - 1;
    else
        v60 = u2;
    end;

    u10 = v60;
    u11 = 0;
    u12 = 0;
    u13 = (-1 / 0);
    u15 = 0;
    u16 = false;
    table.clear(u5);
    u6 = 0;
    u7 = false;
    local v61 = u1[u10];
    LocalPlayer:SetAttribute("AutoQualityBucket", v61.Name);
    LocalPlayer:SetAttribute("AutoQualityCullRange", v61.CullRange);
    LocalPlayer:SetAttribute("AutoQualityAgeMaxHz", v61.AgeMaxHz);
    LocalPlayer:SetAttribute("AutoQualityPlantBudget", v61.PlantBudget);
end;

return {
    StartOrder = 50,

    Init = function(p62) -- Line: 320, Name: Init
    end,

    Start = function(p63) -- Line: 323, Name: Start
        -- upvalues: u17 (ref), u2 (copy), u1 (copy), LocalPlayer (copy), UserInputService (copy), u8 (ref), u7 (ref), SetEnabled (copy), PerfFlags (copy), ABTests (copy), RunService (copy), u4 (ref), u9 (copy), u6 (ref), u5 (copy), EvaluateWindow (copy)
        u17 = require(script.Parent.PlantVisualizerController);
        local v64 = u1[u2];
        LocalPlayer:SetAttribute("AutoQualityBucket", v64.Name);
        LocalPlayer:SetAttribute("AutoQualityCullRange", v64.CullRange);
        LocalPlayer:SetAttribute("AutoQualityAgeMaxHz", v64.AgeMaxHz);
        LocalPlayer:SetAttribute("AutoQualityPlantBudget", v64.PlantBudget);
        LocalPlayer:SetAttribute("AutoQualityActive", false);
        UserInputService.WindowFocused:Connect(function() -- Line: 331
            -- upvalues: u8 (ref)
            u8 = true;
        end);
        UserInputService.WindowFocusReleased:Connect(function() -- Line: 334
            -- upvalues: u8 (ref), u7 (ref)
            u8 = false;
            u7 = true;
        end);

        local function refreshEnabled() -- Line: 339
            -- upvalues: SetEnabled (ref), PerfFlags (ref), ABTests (ref), LocalPlayer (ref)
            local v65;

            if PerfFlags.AutoQualityEnabled:Get() then
                v65 = ABTests.GetAttribute(LocalPlayer, "Perf.AutoQuality.Enabled", false);

                if type(v65) ~= "boolean" then
                    v65 = false;
                end;
            else
                v65 = false;
            end;

            SetEnabled(v65);
        end;

        if ABTests.IsLoaded() then
            local v66;

            if PerfFlags.AutoQualityEnabled:Get() then
                v66 = ABTests.GetAttribute(LocalPlayer, "Perf.AutoQuality.Enabled", false);

                if type(v66) ~= "boolean" then
                    v66 = false;
                end;
            else
                v66 = false;
            end;

            SetEnabled(v66);
        else
            task.spawn(function() -- Line: 346
                -- upvalues: ABTests (ref), SetEnabled (ref), PerfFlags (ref), LocalPlayer (ref)
                ABTests.Loaded:Wait();
                local v67;

                if PerfFlags.AutoQualityEnabled:Get() then
                    v67 = ABTests.GetAttribute(LocalPlayer, "Perf.AutoQuality.Enabled", false);

                    if type(v67) ~= "boolean" then
                        v67 = false;
                    end;
                else
                    v67 = false;
                end;

                SetEnabled(v67);
            end);
        end;

        PerfFlags.AutoQualityEnabled.Changed:Connect(refreshEnabled);
        ABTests.PlayerUpdated:Connect(function(p68) -- Line: 353
            -- upvalues: LocalPlayer (ref), SetEnabled (ref), PerfFlags (ref), ABTests (ref)
            if p68 == LocalPlayer then
                local v69;

                if PerfFlags.AutoQualityEnabled:Get() then
                    v69 = ABTests.GetAttribute(LocalPlayer, "Perf.AutoQuality.Enabled", false);

                    if type(v69) ~= "boolean" then
                        v69 = false;
                    end;
                else
                    v69 = false;
                end;

                SetEnabled(v69);
            end;
        end);
        RunService.RenderStepped:Connect(function(p70) -- Line: 359
            -- upvalues: u4 (ref), u8 (ref), u9 (ref), LocalPlayer (ref), u17 (ref), u6 (ref), u5 (ref), u7 (ref), PerfFlags (ref), EvaluateWindow (ref)
            if not u4 then
                return;
            end;

            local v71;

            if u4 and (u8 and (os.clock() - u9 >= 30 and LocalPlayer:GetAttribute("LoadingScreenActive") ~= true)) then
                v71 = not (u17 and u17:GetOfflineCutsceneState());
            else
                v71 = false;
            end;

            if not v71 then
                if u6 > 0 or #u5 > 0 then
                    table.clear(u5);
                    u6 = 0;
                    u7 = false;
                end;

                return;
            end;

            table.insert(u5, p70);
            u6 = u6 + p70;

            if u6 >= PerfFlags.AutoQualityWindowSeconds:Get() then
                if not u7 then
                    EvaluateWindow();
                end;

                table.clear(u5);
                u6 = 0;
                u7 = false;
            end;
        end);
    end
};