-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Stats = game:GetService("Stats");
local BenchmarkPackets = require(ReplicatedStorage.SharedModules.BenchmarkPackets);
local u1 = false;

local function SafeNumber(p2, p3) -- Line: 45
    local success, result = pcall(p2);

    if success and type(result) == "number" then
        return result;
    end;

    return p3;
end;

local function TakeStatSample() -- Line: 53
    -- upvalues: Stats (copy)
    local v4 = {};
    local success, result = pcall(function() -- Line: 55
        -- upvalues: Stats (ref)
        return Stats.SceneDrawcallCount;
    end);
    v4.Drawcalls = (not success or type(result) ~= "number") and 0 or result;
    local success2, result2 = pcall(function() -- Line: 56
        -- upvalues: Stats (ref)
        return Stats.SceneTriangleCount;
    end);
    v4.Triangles = (not success2 or type(result2) ~= "number") and 0 or result2;
    local success3, result3 = pcall(function() -- Line: 57
        -- upvalues: Stats (ref)
        return Stats.InstanceCount;
    end);
    v4.InstanceCount = (not success3 or type(result3) ~= "number") and 0 or result3;
    local success4, result4 = pcall(function() -- Line: 58
        -- upvalues: Stats (ref)
        return Stats:GetTotalMemoryUsageMb();
    end);
    v4.MemoryMb = (not success4 or type(result4) ~= "number") and 0 or result4;
    local success5, result5 = pcall(function() -- Line: 59
        return workspace:GetRealPhysicsFPS();
    end);
    v4.PhysicsFps = (not success5 or type(result5) ~= "number") and 0 or result5;
    local success6, result6 = pcall(function() -- Line: 60
        return workspace:GetNumAwakeParts();
    end);
    v4.AwakeParts = (not success6 or type(result6) ~= "number") and 0 or result6;
    local success7, result7 = pcall(function() -- Line: 61
        -- upvalues: Stats (ref)
        return Stats.HeartbeatTime * 1000;
    end);
    v4.HeartbeatMs = (not success7 or type(result7) ~= "number") and 0 or result7;
    local success8, result8 = pcall(function() -- Line: 62
        -- upvalues: Stats (ref)
        return Stats.RenderCPUFrameTime;
    end);
    v4.RenderCpuMs = (not success8 or type(result8) ~= "number") and 0 or result8;
    local success9, result9 = pcall(function() -- Line: 63
        -- upvalues: Stats (ref)
        return Stats.RenderGPUFrameTime;
    end);
    v4.RenderGpuMs = (not success9 or type(result9) ~= "number") and 0 or result9;

    return v4;
end;

local function Percentile(p5, p6) -- Line: 67
    local v7 = #p5;

    if v7 == 0 then
        return 0;
    end;

    local v8 = math.ceil(p6 * v7);

    return p5[math.clamp(v8, 1, v7)];
end;

local function Average(p9) -- Line: 74
    local v10 = #p9;

    if v10 == 0 then
        return 0;
    end;

    local v11 = 0;

    for _, v in p9 do
        v11 = v11 + v;
    end;

    return v11 / v10;
end;

local function OnePercentLowFps(p12) -- Line: 85
    local v13 = #p12;

    if v13 == 0 then
        return 0;
    end;

    local v14 = math.floor(v13 * 0.01);
    local v15 = math.max(1, v14);
    local v16 = 0;

    for i = v13 - v15 + 1, v13 do
        v16 = v16 + p12[i];
    end;

    local v17 = v16 / v15;

    return v17 <= 0 and 0 or 1 / v17;
end;

local function BuildReport(p18, p19, p20, p21, p22, p23) -- Line: 98
    table.sort(p20);
    local v24 = #p20;
    local v25;

    if v24 == 0 then
        v25 = 0;
    else
        local v26 = 0;

        for _, v in p20 do
            v26 = v26 + v;
        end;

        v25 = v26 / v24;
    end;

    local v27 = v25 <= 0 and 0 or 1 / v25;
    local v28 = #p20 <= 0 and 0 or p20[#p20];
    local v29 = #p20;
    local v30;

    if v29 == 0 then
        v30 = 0;
    else
        local v31 = math.ceil(v29 * 0.5);
        v30 = p20[math.clamp(v31, 1, v29)];
    end;

    local v32 = #p20;
    local v33;

    if v32 == 0 then
        v33 = 0;
    else
        local v34 = math.ceil(v32 * 0.99);
        v33 = p20[math.clamp(v34, 1, v32)];
    end;

    local v35 = v33 * 1000;
    local v36 = #p20;
    local v37;

    if v36 == 0 then
        v37 = 0;
    else
        local v38 = math.floor(v36 * 0.01);
        local v39 = math.max(1, v38);
        local v40 = 0;

        for i = v36 - v39 + 1, v36 do
            v40 = v40 + p20[i];
        end;

        local v41 = v40 / v39;

        if v41 <= 0 then
            v37 = 0;
        else
            v37 = 1 / v41;
        end;
    end;

    local v42 = {};
    local v43 = {};
    local v44 = {};
    local v45 = {};
    local v46 = {};
    local v47 = {};
    local v48 = {};
    local v49 = {};
    local v50 = {};

    for _, v in p21 do
        table.insert(v44, v.Drawcalls);
        table.insert(v45, v.Triangles);
        table.insert(v46, v.InstanceCount);
        table.insert(v47, v.MemoryMb);
        table.insert(v48, v.PhysicsFps);
        table.insert(v49, v.AwakeParts);
        table.insert(v50, v.HeartbeatMs);
        table.insert(v42, v.RenderCpuMs);
        table.insert(v43, v.RenderGpuMs);
    end;

    local v51;

    if #v46 > 0 then
        v51 = v46[#v46];
    else
        v51 = p22;
    end;

    local v52;

    if #v47 > 0 then
        v52 = v47[#v47];
    else
        v52 = p23;
    end;

    local v53 = math.max(50, 1000 / p19 * 1.5);
    local v54 = {
        Scenario = p18,
        TargetFps = p19,
        Verdict = p19 <= v27 and v35 <= v53 and "PASS" or "FAIL",
        Frames = #p20,
        AvgFps = v27,
        MinFps = v28 <= 0 and 0 or 1 / v28,
        OnePercentLowFps = v37,
        P50FrameMs = v30 * 1000,
        P99FrameMs = v35,
        P99BudgetMs = v53
    };
    local v55 = #v44;
    local v56;

    if v55 == 0 then
        v56 = 0;
    else
        local v57 = 0;

        for _, v in v44 do
            v57 = v57 + v;
        end;

        v56 = v57 / v55;
    end;

    v54.AvgDrawcalls = v56;
    local v58 = #v45;
    local v59;

    if v58 == 0 then
        v59 = 0;
    else
        local v60 = 0;

        for _, v in v45 do
            v60 = v60 + v;
        end;

        v59 = v60 / v58;
    end;

    v54.AvgTriangles = v59;
    local v61 = #v46;
    local v62;

    if v61 == 0 then
        v62 = 0;
    else
        local v63 = 0;

        for _, v in v46 do
            v63 = v63 + v;
        end;

        v62 = v63 / v61;
    end;

    v54.AvgInstanceCount = v62;
    v54.InstanceDelta = v51 - p22;
    local v64 = #v47;
    local v65;

    if v64 == 0 then
        v65 = 0;
    else
        local v66 = 0;

        for _, v in v47 do
            v66 = v66 + v;
        end;

        v65 = v66 / v64;
    end;

    v54.AvgMemoryMb = v65;
    v54.MemoryDeltaMb = v52 - p23;
    local v67 = #v48;
    local v68;

    if v67 == 0 then
        v68 = 0;
    else
        local v69 = 0;

        for _, v in v48 do
            v69 = v69 + v;
        end;

        v68 = v69 / v67;
    end;

    v54.AvgPhysicsFps = v68;
    local v70 = #v49;
    local v71;

    if v70 == 0 then
        v71 = 0;
    else
        local v72 = 0;

        for _, v in v49 do
            v72 = v72 + v;
        end;

        v71 = v72 / v70;
    end;

    v54.AvgAwakeParts = v71;
    local v73 = #v50;
    local v74;

    if v73 == 0 then
        v74 = 0;
    else
        local v75 = 0;

        for _, v in v50 do
            v75 = v75 + v;
        end;

        v74 = v75 / v73;
    end;

    v54.AvgHeartbeatMs = v74;
    local v76 = #v42;
    local v77;

    if v76 == 0 then
        v77 = 0;
    else
        local v78 = 0;

        for _, v in v42 do
            v78 = v78 + v;
        end;

        v77 = v78 / v76;
    end;

    v54.AvgRenderCpuMs = v77;
    local v79 = #v43;
    local v80;

    if v79 == 0 then
        v80 = 0;
    else
        local v81 = 0;

        for _, v in v43 do
            v81 = v81 + v;
        end;

        v80 = v81 / v79;
    end;

    v54.AvgRenderGpuMs = v80;

    return v54;
end;

local function PrintReport(p82) -- Line: 165
    local u83 = "?";
    pcall(function() -- Line: 167
        -- upvalues: u83 (ref)
        local SavedQualityLevel = UserSettings().GameSettings.SavedQualityLevel;
        u83 = tostring(SavedQualityLevel);
    end);
    local v84 = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.zero;
    local v85 = {
        "========================================",
        string.format("  BENCHMARK [%s]  %s", p82.Scenario, p82.Verdict),
        "----------------------------------------",
        string.format("  Quality:%s  Viewport:%dx%d  Frames:%d", u83, v84.X, v84.Y, p82.Frames),
        string.format("  Avg FPS:        %.1f  (target %d)", p82.AvgFps, p82.TargetFps),
        string.format("  1%% low FPS:     %.1f", p82.OnePercentLowFps),
        string.format("  Min FPS:        %.1f", p82.MinFps),
        string.format("  Frame p50:      %.1f ms", p82.P50FrameMs),
        string.format("  Frame p99:      %.1f ms  (budget %.0f)", p82.P99FrameMs, p82.P99BudgetMs),
        string.format("  Heartbeat:      %.2f ms", p82.AvgHeartbeatMs),
        string.format("  Render CPU/GPU: %.1f / %.1f ms", p82.AvgRenderCpuMs, p82.AvgRenderGpuMs),
        string.format("  Draw calls:     %d", (math.floor(p82.AvgDrawcalls))),
        string.format("  Triangles:      %d", (math.floor(p82.AvgTriangles))),
        string.format("  Instances:      %d  (%+d)", math.floor(p82.AvgInstanceCount), (math.floor(p82.InstanceDelta))),
        string.format("  Memory:         %.0f MB  (%+.0f)", p82.AvgMemoryMb, p82.MemoryDeltaMb),
        string.format("  Physics FPS:    %.0f  Awake parts: %d", p82.AvgPhysicsFps, (math.floor(p82.AvgAwakeParts))),
        "========================================"
    };
    local v86 = table.concat(v85, "\n");

    if p82.Verdict == "FAIL" then
        warn(v86);
    else
        print(v86);
    end;
end;

local function RunSampling(u87, p88, u89) -- Line: 200
    -- upvalues: u1 (ref), Stats (copy), TakeStatSample (copy), RunService (copy), BuildReport (copy), PrintReport (copy), BenchmarkPackets (copy)
    if u1 then
        warn("[BenchmarkController] a benchmark is already running; ignoring new request");

        return;
    end;

    u1 = true;
    local success, result = pcall(function() -- Line: 207
        -- upvalues: Stats (ref)
        return Stats.InstanceCount;
    end);
    local u90 = (not success or type(result) ~= "number") and 0 or result;
    local success2, result2 = pcall(function() -- Line: 208
        -- upvalues: Stats (ref)
        return Stats:GetTotalMemoryUsageMb();
    end);
    local u91 = (not success2 or type(result2) ~= "number") and 0 or result2;
    local u92 = {};
    local u93 = { (TakeStatSample()) };
    local u94 = 0;
    print(string.format("[BenchmarkController] sampling %q for %ds (target %d FPS)...", u87, p88, u89));
    local u95 = os.clock() + p88;
    local u96 = nil;
    u96 = RunService.RenderStepped:Connect(function(p97) -- Line: 218
        -- upvalues: u92 (copy), u94 (ref), u93 (copy), TakeStatSample (ref), u95 (copy), u96 (ref), BuildReport (ref), u87 (copy), u89 (copy), u90 (copy), u91 (copy), PrintReport (ref), BenchmarkPackets (ref), u1 (ref)
        table.insert(u92, p97);
        u94 = u94 + p97;

        if u94 >= 0.5 then
            u94 = 0;
            local v98 = TakeStatSample();
            table.insert(u93, v98);
        end;

        if u95 <= os.clock() then
            u96:Disconnect();
            local v99 = TakeStatSample();
            table.insert(u93, v99);
            local u100 = BuildReport(u87, u89, u92, u93, u90, u91);
            PrintReport(u100);
            pcall(function() -- Line: 230
                -- upvalues: BenchmarkPackets (ref), u87 (ref), u100 (copy)
                BenchmarkPackets.Result:Fire(u87, u100);
            end);
            u1 = false;
        end;
    end);
end;

return {
    Init = function(p101) -- Line: 241, Name: Init
        -- upvalues: RunService (copy), Players (copy), BenchmarkPackets (copy), RunSampling (copy)
        if RunService:IsServer() then
            return;
        end;

        if not Players.LocalPlayer then
            return;
        end;

        BenchmarkPackets.Start.OnClientEvent:Connect(function(p102, p103, p104) -- Line: 245
            -- upvalues: RunSampling (ref)
            RunSampling(p102, p103, p104);
        end);
    end
};