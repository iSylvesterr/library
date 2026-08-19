-- Decompiled with Potassium's decompiler.

require(script.Parent.TypeDefinitions);
local TypeMarshaller = require(script.Parent.TypeMarshaller);
local u1 = {};
u1.__index = u1;
u1.__type = "ActiveCast";
local RunService = game:GetService("RunService");
local Table = require(script.Parent.Table);
local u2 = nil;

local function GetFastCastVisualizationContainer() -- Line: 61
    local FastCastVisualizationObjects = workspace.Terrain:FindFirstChild("FastCastVisualizationObjects");

    if FastCastVisualizationObjects ~= nil then
        return FastCastVisualizationObjects;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "FastCastVisualizationObjects";
    Folder.Archivable = false;
    Folder.Parent = workspace.Terrain;

    return Folder;
end;

local function PrintDebug(p3) -- Line: 79
    -- upvalues: u2 (ref)
    if u2.DebugLogging == true then
        print(p3);
    end;
end;

function DbgVisualizeSegment(p4, p5)
    -- upvalues: u2 (ref)
    if u2.VisualizeCasts ~= true then
        return nil;
    end;

    local ConeHandleAdornment = Instance.new("ConeHandleAdornment");
    ConeHandleAdornment.Adornee = workspace.Terrain;
    ConeHandleAdornment.CFrame = p4;
    ConeHandleAdornment.Height = p5;
    ConeHandleAdornment.Color3 = Color3.new();
    ConeHandleAdornment.Radius = 0.25;
    ConeHandleAdornment.Transparency = 0.5;
    local FastCastVisualizationObjects = workspace.Terrain:FindFirstChild("FastCastVisualizationObjects");

    if FastCastVisualizationObjects == nil then
        FastCastVisualizationObjects = Instance.new("Folder");
        FastCastVisualizationObjects.Name = "FastCastVisualizationObjects";
        FastCastVisualizationObjects.Archivable = false;
        FastCastVisualizationObjects.Parent = workspace.Terrain;
    end;

    ConeHandleAdornment.Parent = FastCastVisualizationObjects;

    return ConeHandleAdornment;
end;

function DbgVisualizeHit(p6, p7)
    -- upvalues: u2 (ref)
    if u2.VisualizeCasts ~= true then
        return nil;
    end;

    local SphereHandleAdornment = Instance.new("SphereHandleAdornment");
    SphereHandleAdornment.Adornee = workspace.Terrain;
    SphereHandleAdornment.CFrame = p6;
    SphereHandleAdornment.Radius = 0.4;
    SphereHandleAdornment.Transparency = 0.25;
    SphereHandleAdornment.Color3 = p7 == false and Color3.new(0.2, 1, 0.5) or Color3.new(1, 0.2, 0.2);
    local FastCastVisualizationObjects = workspace.Terrain:FindFirstChild("FastCastVisualizationObjects");

    if FastCastVisualizationObjects == nil then
        FastCastVisualizationObjects = Instance.new("Folder");
        FastCastVisualizationObjects.Name = "FastCastVisualizationObjects";
        FastCastVisualizationObjects.Archivable = false;
        FastCastVisualizationObjects.Parent = workspace.Terrain;
    end;

    SphereHandleAdornment.Parent = FastCastVisualizationObjects;

    return SphereHandleAdornment;
end;

local function GetPositionAtTime(p8, p9, p10, p11) -- Line: 124
    local v12 = Vector3.new(p11.X * p8 ^ 2 / 2, p11.Y * p8 ^ 2 / 2, p11.Z * p8 ^ 2 / 2);

    return p9 + p10 * p8 + v12;
end;

local function GetVelocityAtTime(p13, p14, p15) -- Line: 136
    return p14 + p15 * p13;
end;

local function GetTrajectoryInfo(p16, p17) -- Line: 140
    assert(p16.StateInfo.UpdateConnection ~= nil, "This ActiveCast has been terminated. It can no longer be used.");
    local v18 = p16.StateInfo.Trajectories[p17];
    local v19 = v18.EndTime - v18.StartTime;
    local Origin = v18.Origin;
    local InitialVelocity = v18.InitialVelocity;
    local Acceleration = v18.Acceleration;
    local v20 = {};
    local v21 = Vector3.new(Acceleration.X * v19 ^ 2 / 2, Acceleration.Y * v19 ^ 2 / 2, Acceleration.Z * v19 ^ 2 / 2);
    v20[1], v20[2] = Origin + InitialVelocity * v19 + v21, InitialVelocity + Acceleration * v19;

    return v20;
end;

local function GetLatestTrajectoryEndInfo(p22) -- Line: 153
    -- upvalues: GetTrajectoryInfo (copy)
    assert(p22.StateInfo.UpdateConnection ~= nil, "This ActiveCast has been terminated. It can no longer be used.");

    return GetTrajectoryInfo(p22, #p22.StateInfo.Trajectories);
end;

local function CloneCastParams(p23) -- Line: 158
    local v24 = RaycastParams.new();
    v24.CollisionGroup = p23.CollisionGroup;
    v24.FilterType = p23.FilterType;
    v24.FilterDescendantsInstances = p23.FilterDescendantsInstances;
    v24.IgnoreWater = p23.IgnoreWater;

    return v24;
end;

local function SendRayHit(p25, p26, p27, p28) -- Line: 167
    p25.Caster.RayHit:Fire(p25, p26, p27, p28);
end;

local function SendRayPierced(p29, p30, p31, p32) -- Line: 177
    p29.Caster.RayPierced:Fire(p29, p30, p31, p32);
end;

local function SendLengthChanged(p33, p34, p35, p36, p37, p38) -- Line: 187
    p33.Caster.LengthChanged:Fire(p33, p34, p35, p36, p37, p38);
end;

local function SimulateCast(p39, p40, p41) -- Line: 200
    -- upvalues: u2 (ref), Table (copy)
    assert(p39.StateInfo.UpdateConnection ~= nil, "This ActiveCast has been terminated. It can no longer be used.");

    if u2.DebugLogging == true then
        print("Casting for frame.");
    end;

    local v42 = p39.StateInfo.Trajectories[#p39.StateInfo.Trajectories];
    local Origin = v42.Origin;
    local v43 = p39.StateInfo.TotalRuntime - v42.StartTime;
    local InitialVelocity = v42.InitialVelocity;
    local Acceleration = v42.Acceleration;
    local v44 = Vector3.new(Acceleration.X * v43 ^ 2 / 2, Acceleration.Y * v43 ^ 2 / 2, Acceleration.Z * v43 ^ 2 / 2);
    local v45 = Origin + InitialVelocity * v43 + v44;
    local _ = InitialVelocity + Acceleration * v43;
    local v46 = p39.StateInfo.TotalRuntime - v42.StartTime;
    local StateInfo = p39.StateInfo;
    StateInfo.TotalRuntime = StateInfo.TotalRuntime + p40;
    local v47 = p39.StateInfo.TotalRuntime - v42.StartTime;
    local v48 = Vector3.new(Acceleration.X * v47 ^ 2 / 2, Acceleration.Y * v47 ^ 2 / 2, Acceleration.Z * v47 ^ 2 / 2);
    local v49 = Origin + InitialVelocity * v47 + v48;
    local v50 = InitialVelocity + Acceleration * v47;
    local v51 = (v49 - v45).Unit * v50.Magnitude * p40;
    local WorldRoot = p39.RayInfo.WorldRoot;
    local v52 = WorldRoot:Raycast(v45, v51, p39.RayInfo.Parameters);
    local Air = Enum.Material.Air;
    Vector3.new();
    local v53, v54;

    if v52 == nil then
        v53 = v49;
        v54 = nil;
    else
        v53 = v52.Position;
        v54 = v52.Instance;
        Air = v52.Material;
        local _ = v52.Normal;
    end;

    local Magnitude = (v53 - v45).Magnitude;
    p39.Caster.LengthChanged:Fire(p39, v45, v51.Unit, Magnitude, v50, p39.RayInfo.CosmeticBulletObject);
    local StateInfo2 = p39.StateInfo;
    StateInfo2.DistanceCovered = StateInfo2.DistanceCovered + Magnitude;
    local v55;

    if p40 > 0 then
        v55 = DbgVisualizeSegment(CFrame.new(v45, v45 + v51), Magnitude);
    else
        v55 = nil;
    end;

    if v54 and v54 ~= p39.RayInfo.CosmeticBulletObject then
        tick();

        if u2.DebugLogging == true then
            print("Hit something, testing now.");
        end;

        if p39.RayInfo.CanPierceCallback ~= nil then
            if p41 == false and p39.StateInfo.IsActivelySimulatingPierce then
                p39:Terminate();
                error("ERROR: The latest call to CanPierceCallback took too long to complete! This cast is going to suffer desyncs which WILL cause unexpected behavior and errors. Please fix your performance problems, or remove statements that yield (e.g. wait() calls)");
            end;

            p39.StateInfo.IsActivelySimulatingPierce = true;
        end;

        if p39.RayInfo.CanPierceCallback == nil or p39.RayInfo.CanPierceCallback ~= nil and p39.RayInfo.CanPierceCallback(p39, v52, v50, p39.RayInfo.CosmeticBulletObject) == false then
            if u2.DebugLogging == true then
                print("Piercing function is nil or it returned FALSE to not pierce this hit.");
            end;

            p39.StateInfo.IsActivelySimulatingPierce = false;

            if p39.StateInfo.HighFidelityBehavior == 2 and (v42.Acceleration ~= Vector3.new() and p39.StateInfo.HighFidelitySegmentSize ~= 0) then
                p39.StateInfo.CancelHighResCast = false;

                if p39.StateInfo.IsActivelyResimulating then
                    p39:Terminate();
                    error("Cascading cast lag encountered! The caster attempted to perform a high fidelity cast before the previous one completed, resulting in exponential cast lag. Consider increasing HighFidelitySegmentSize.");
                end;

                p39.StateInfo.IsActivelyResimulating = true;

                if u2.DebugLogging == true then
                    print("Hit was registered, but recalculation is on for physics based casts. Recalculating to verify a real hit...");
                end;

                local v56 = math.floor(Magnitude / p39.StateInfo.HighFidelitySegmentSize);
                local _ = Magnitude / v56;
                local v57 = p40 / v56;

                for i = 1, v56 do
                    if p39.StateInfo.CancelHighResCast then
                        p39.StateInfo.CancelHighResCast = false;
                        break;
                    end;

                    local v58 = v46 + v57 * i;
                    local v59 = Vector3.new(Acceleration.X * v58 ^ 2 / 2, Acceleration.Y * v58 ^ 2 / 2, Acceleration.Z * v58 ^ 2 / 2);
                    local v60 = Origin + InitialVelocity * v58 + v59;
                    local v61 = InitialVelocity + Acceleration * (v46 + v57 * i);
                    local v62 = WorldRoot:Raycast(v60, v61 * p40, p39.RayInfo.Parameters);
                    local Magnitude2 = (v60 - (v60 + v61)).Magnitude;

                    if v62 == nil then
                        local v63 = DbgVisualizeSegment(CFrame.new(v60, v60 + v61), Magnitude2);

                        if v63 ~= nil then
                            v63.Color3 = Color3.new(0.286275, 0.329412, 0.247059);
                        end;
                    else
                        local Magnitude3 = (v60 - v62.Position).Magnitude;
                        local v64 = DbgVisualizeSegment(CFrame.new(v60, v60 + v61), Magnitude3);

                        if v64 ~= nil then
                            v64.Color3 = Color3.new(0.286275, 0.329412, 0.247059);
                        end;

                        if p39.RayInfo.CanPierceCallback == nil or p39.RayInfo.CanPierceCallback ~= nil and p39.RayInfo.CanPierceCallback(p39, v62, v61, p39.RayInfo.CosmeticBulletObject) == false then
                            p39.StateInfo.IsActivelyResimulating = false;
                            p39.Caster.RayHit:Fire(p39, v62, v61, p39.RayInfo.CosmeticBulletObject);
                            p39:Terminate();
                            local v65 = DbgVisualizeHit(CFrame.new(v53), false);

                            if v65 ~= nil then
                                v65.Color3 = Color3.new(0.0588235, 0.87451, 1);
                            end;

                            return;
                        end;

                        p39.Caster.RayPierced:Fire(p39, v62, v61, p39.RayInfo.CosmeticBulletObject);
                        local v66 = DbgVisualizeHit(CFrame.new(v53), true);

                        if v66 ~= nil then
                            v66.Color3 = Color3.new(1, 0.113725, 0.588235);
                        end;

                        if v64 ~= nil then
                            v64.Color3 = Color3.new(0.305882, 0.243137, 0.329412);
                        end;
                    end;
                end;

                p39.StateInfo.IsActivelyResimulating = false;
            else
                if p39.StateInfo.HighFidelityBehavior == 1 or p39.StateInfo.HighFidelityBehavior == 3 then
                    if u2.DebugLogging == true then
                        print("Hit was successful. Terminating.");
                    end;

                    p39.Caster.RayHit:Fire(p39, v52, v50, p39.RayInfo.CosmeticBulletObject);
                    p39:Terminate();
                    DbgVisualizeHit(CFrame.new(v53), false);

                    return;
                end;

                p39:Terminate();
                error("Invalid value " .. p39.StateInfo.HighFidelityBehavior .. " for HighFidelityBehavior.");
            end;
        else
            if u2.DebugLogging == true then
                print("Piercing function returned TRUE to pierce this part.");
            end;

            if v55 ~= nil then
                v55.Color3 = Color3.new(0.4, 0.05, 0.05);
            end;

            DbgVisualizeHit(CFrame.new(v53), true);
            local Parameters = p39.RayInfo.Parameters;
            local FilterDescendantsInstances = Parameters.FilterDescendantsInstances;
            local v67 = {};
            local v68 = false;
            local v69 = 0;

            while true do
                if v52.Instance:IsA("Terrain") then
                    if Air == Enum.Material.Water then
                        p39:Terminate();
                        error(
                            "Do not add Water as a piercable material. If you need to pierce water, set cast.RayInfo.Parameters.IgnoreWater = true instead",
                            0
                        );
                    end;

                    warn("WARNING: The pierce callback for this cast returned TRUE on Terrain! This can cause severely adverse effects.");
                end;

                if Parameters.FilterType == Enum.RaycastFilterType.Blacklist then
                    local FilterDescendantsInstances2 = Parameters.FilterDescendantsInstances;
                    Table.insert(FilterDescendantsInstances2, v52.Instance);
                    Table.insert(v67, v52.Instance);
                    Parameters.FilterDescendantsInstances = FilterDescendantsInstances2;
                else
                    local FilterDescendantsInstances2 = Parameters.FilterDescendantsInstances;
                    Table.removeObject(FilterDescendantsInstances2, v52.Instance);
                    Table.insert(v67, v52.Instance);
                    Parameters.FilterDescendantsInstances = FilterDescendantsInstances2;
                end;

                p39.Caster.RayPierced:Fire(p39, v52, v50, p39.RayInfo.CosmeticBulletObject);
                v52 = WorldRoot:Raycast(v45, v51, Parameters);

                if v52 == nil then
                    break;
                end;

                if v69 >= 100 then
                    warn("WARNING: Exceeded maximum pierce test budget for a single ray segment (attempted to test the same segment " .. 100 .. " times!)");
                    break;
                end;

                v69 = v69 + 1;

                if p39.RayInfo.CanPierceCallback(p39, v52, v50, p39.RayInfo.CosmeticBulletObject) == false then
                    v68 = true;
                    break;
                end;
            end;

            p39.RayInfo.Parameters.FilterDescendantsInstances = FilterDescendantsInstances;
            p39.StateInfo.IsActivelySimulatingPierce = false;

            if v68 then
                local v70 = "Broke because the ray hit something solid (" .. tostring(v52.Instance) .. ") while testing for a pierce. Terminating the cast.";

                if u2.DebugLogging == true then
                    print(v70);
                end;

                p39.Caster.RayHit:Fire(p39, v52, v50, p39.RayInfo.CosmeticBulletObject);
                p39:Terminate();
                DbgVisualizeHit(CFrame.new(v52.Position), false);

                return;
            end;
        end;
    end;

    if p39.StateInfo.DistanceCovered >= p39.RayInfo.MaxDistance then
        p39:Terminate();
        DbgVisualizeHit(CFrame.new(v49), false);
    end;
end;

function u1.new(p71, p72, p73, p74, p75) -- Line: 518
    -- upvalues: TypeMarshaller (copy), Table (copy), RunService (copy), u1 (copy), u2 (ref), SimulateCast (copy)
    if TypeMarshaller(p74) == "number" then
        p74 = p73.Unit * p74;
    end;

    if p75.HighFidelitySegmentSize <= 0 then
        error("Cannot set FastCastBehavior.HighFidelitySegmentSize <= 0!", 0);
    end;

    local u76 = {
        Caster = p71,
        StateInfo = {
            UpdateConnection = nil,
            Paused = false,
            TotalRuntime = 0,
            DistanceCovered = 0,
            IsActivelySimulatingPierce = false,
            IsActivelyResimulating = false,
            CancelHighResCast = false,
            HighFidelitySegmentSize = p75.HighFidelitySegmentSize,
            HighFidelityBehavior = p75.HighFidelityBehavior,
            Trajectories = {
                {
                    StartTime = 0,
                    EndTime = -1,
                    Origin = p72,
                    InitialVelocity = p74,
                    Acceleration = p75.Acceleration
                }
            }
        },
        RayInfo = {
            Parameters = p75.RaycastParams,
            WorldRoot = workspace,
            MaxDistance = p75.MaxDistance or 1000,
            CosmeticBulletObject = p75.CosmeticBulletTemplate,
            CanPierceCallback = p75.CanPierceFunction
        },
        UserData = {}
    };

    if u76.StateInfo.HighFidelityBehavior == 2 then
        u76.StateInfo.HighFidelityBehavior = 3;
    end;

    if u76.RayInfo.Parameters == nil then
        u76.RayInfo.Parameters = RaycastParams.new();
    else
        local RayInfo = u76.RayInfo;
        local Parameters = u76.RayInfo.Parameters;
        local v77 = RaycastParams.new();
        v77.CollisionGroup = Parameters.CollisionGroup;
        v77.FilterType = Parameters.FilterType;
        v77.FilterDescendantsInstances = Parameters.FilterDescendantsInstances;
        v77.IgnoreWater = Parameters.IgnoreWater;
        RayInfo.Parameters = v77;
    end;

    local v78 = false;

    if p75.CosmeticBulletProvider == nil then
        if u76.RayInfo.CosmeticBulletObject ~= nil then
            u76.RayInfo.CosmeticBulletObject = u76.RayInfo.CosmeticBulletObject:Clone();
            u76.RayInfo.CosmeticBulletObject.CFrame = CFrame.new(p72, p72 + p73);
            u76.RayInfo.CosmeticBulletObject.Parent = p75.CosmeticBulletContainer;
        end;
    elseif TypeMarshaller(p75.CosmeticBulletProvider) == "PartCache" then
        if u76.RayInfo.CosmeticBulletObject ~= nil then
            warn("Do not define FastCastBehavior.CosmeticBulletTemplate and FastCastBehavior.CosmeticBulletProvider at the same time! The provider will be used, and CosmeticBulletTemplate will be set to nil.");
            u76.RayInfo.CosmeticBulletObject = nil;
            p75.CosmeticBulletTemplate = nil;
        end;

        u76.RayInfo.CosmeticBulletObject = p75.CosmeticBulletProvider:GetPart();
        u76.RayInfo.CosmeticBulletObject.CFrame = CFrame.new(p72, p72 + p73);
        v78 = true;
    else
        warn("FastCastBehavior.CosmeticBulletProvider was not an instance of the PartCache module (an external/separate model)! Are you inputting an instance created via PartCache.new? If so, are you on the latest version of PartCache? Setting FastCastBehavior.CosmeticBulletProvider to nil.");
        p75.CosmeticBulletProvider = nil;
    end;

    local v79;

    if v78 then
        v79 = p75.CosmeticBulletProvider.CurrentCacheParent;
    else
        v79 = p75.CosmeticBulletContainer;
    end;

    if p75.AutoIgnoreContainer == true and v79 ~= nil then
        local FilterDescendantsInstances = u76.RayInfo.Parameters.FilterDescendantsInstances;

        if Table.find(FilterDescendantsInstances, v79) == nil then
            Table.insert(FilterDescendantsInstances, v79);
            u76.RayInfo.Parameters.FilterDescendantsInstances = FilterDescendantsInstances;
        end;
    end;

    local v80;

    if RunService:IsClient() then
        v80 = RunService.RenderStepped;
    else
        v80 = RunService.Heartbeat;
    end;

    setmetatable(u76, u1);
    u76.StateInfo.UpdateConnection = v80:Connect(function(p81) -- Line: 640
        -- upvalues: u76 (copy), u2 (ref), SimulateCast (ref)
        if u76.StateInfo.Paused then
            return;
        end;

        if u2.DebugLogging == true then
            print("Casting for frame.");
        end;

        local v82 = u76.StateInfo.Trajectories[#u76.StateInfo.Trajectories];

        if u76.StateInfo.HighFidelityBehavior == 3 and (v82.Acceleration ~= Vector3.new() and u76.StateInfo.HighFidelitySegmentSize > 0) then
            local v83 = tick();

            if u76.StateInfo.IsActivelyResimulating then
                u76:Terminate();
                error("Cascading cast lag encountered! The caster attempted to perform a high fidelity cast before the previous one completed, resulting in exponential cast lag. Consider increasing HighFidelitySegmentSize.");
            end;

            u76.StateInfo.IsActivelyResimulating = true;
            local Origin = v82.Origin;
            local v84 = u76.StateInfo.TotalRuntime - v82.StartTime;
            local InitialVelocity = v82.InitialVelocity;
            local Acceleration = v82.Acceleration;
            local v85 = Vector3.new(Acceleration.X * v84 ^ 2 / 2, Acceleration.Y * v84 ^ 2 / 2, Acceleration.Z * v84 ^ 2 / 2);
            local v86 = Origin + InitialVelocity * v84 + v85;
            local _ = InitialVelocity + Acceleration * v84;
            local _ = u76.StateInfo.TotalRuntime - v82.StartTime;
            local StateInfo = u76.StateInfo;
            StateInfo.TotalRuntime = StateInfo.TotalRuntime + p81;
            local v87 = u76.StateInfo.TotalRuntime - v82.StartTime;
            local v88 = Vector3.new(Acceleration.X * v87 ^ 2 / 2, Acceleration.Y * v87 ^ 2 / 2, Acceleration.Z * v87 ^ 2 / 2);
            local v89 = Origin + InitialVelocity * v87 + v88;
            local v90 = u76.RayInfo.WorldRoot:Raycast(v86, (v89 - v86).Unit * (InitialVelocity + Acceleration * v87).Magnitude * p81, u76.RayInfo.Parameters);

            if v90 ~= nil then
                v89 = v90.Position;
            end;

            local Magnitude = (v89 - v86).Magnitude;
            local StateInfo2 = u76.StateInfo;
            StateInfo2.TotalRuntime = StateInfo2.TotalRuntime - p81;
            local v91 = math.floor(Magnitude / u76.StateInfo.HighFidelitySegmentSize);
            local v92 = v91 == 0 and 1 or v91;
            local v93 = p81 / v92;

            for i = 1, v92 do
                if getmetatable(u76) == nil then
                    return;
                end;

                if u76.StateInfo.CancelHighResCast then
                    u76.StateInfo.CancelHighResCast = false;
                    break;
                end;

                local v94 = "[" .. i .. "] Subcast of time increment " .. v93;

                if u2.DebugLogging == true then
                    print(v94);
                end;

                SimulateCast(u76, v93, true);
            end;

            if getmetatable(u76) == nil then
                return;
            end;

            u76.StateInfo.IsActivelyResimulating = false;

            if tick() - v83 > 0.08 then
                warn("Extreme cast lag encountered! Consider increasing HighFidelitySegmentSize.");
            end;
        else
            SimulateCast(u76, p81, false);
        end;
    end);

    return u76;
end;

function u1.SetStaticFastCastReference(p95) -- Line: 734
    -- upvalues: u2 (ref)
    u2 = p95;
end;

local function ModifyTransformation(p96, p97, p98, p99) -- Line: 740
    -- upvalues: GetTrajectoryInfo (copy), Table (copy)
    local Trajectories = p96.StateInfo.Trajectories;
    local v100 = Trajectories[#Trajectories];

    if v100.StartTime == p96.StateInfo.TotalRuntime then
        if p97 == nil then
            p97 = v100.InitialVelocity;
        end;

        if p98 == nil then
            p98 = v100.Acceleration;
        end;

        if p99 == nil then
            p99 = v100.Origin;
        end;

        v100.Origin = p99;
        v100.InitialVelocity = p97;
        v100.Acceleration = p98;

        return;
    end;

    v100.EndTime = p96.StateInfo.TotalRuntime;
    assert(p96.StateInfo.UpdateConnection ~= nil, "This ActiveCast has been terminated. It can no longer be used.");
    local v101 = GetTrajectoryInfo(p96, #p96.StateInfo.Trajectories);
    local v102, v103 = unpack(v101);

    if p97 == nil then
        p97 = v103;
    end;

    if p98 == nil then
        p98 = v100.Acceleration;
    end;

    if p99 ~= nil then
        v102 = p99;
    end;

    Table.insert(p96.StateInfo.Trajectories, {
        EndTime = -1,
        StartTime = p96.StateInfo.TotalRuntime,
        Origin = v102,
        InitialVelocity = p97,
        Acceleration = p98
    });
    p96.StateInfo.CancelHighResCast = true;
end;

function u1.SetVelocity(p104, p105) -- Line: 786
    -- upvalues: u1 (copy), ModifyTransformation (copy)
    local v106 = getmetatable(p104) == u1;
    assert(v106, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("SetVelocity", "ActiveCast.new(...)"));
    assert(p104.StateInfo.UpdateConnection ~= nil, "This ActiveCast has been terminated. It can no longer be used.");
    ModifyTransformation(p104, p105, nil, nil);
end;

function u1.SetAcceleration(p107, p108) -- Line: 792
    -- upvalues: u1 (copy), ModifyTransformation (copy)
    local v109 = getmetatable(p107) == u1;
    assert(v109, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("SetAcceleration", "ActiveCast.new(...)"));
    assert(p107.StateInfo.UpdateConnection ~= nil, "This ActiveCast has been terminated. It can no longer be used.");
    ModifyTransformation(p107, nil, p108, nil);
end;

function u1.SetPosition(p110, p111) -- Line: 798
    -- upvalues: u1 (copy), ModifyTransformation (copy)
    local v112 = getmetatable(p110) == u1;
    assert(v112, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("SetPosition", "ActiveCast.new(...)"));
    assert(p110.StateInfo.UpdateConnection ~= nil, "This ActiveCast has been terminated. It can no longer be used.");
    ModifyTransformation(p110, nil, nil, p111);
end;

function u1.GetVelocity(p113) -- Line: 804
    -- upvalues: u1 (copy)
    local v114 = getmetatable(p113) == u1;
    assert(v114, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("GetVelocity", "ActiveCast.new(...)"));
    assert(p113.StateInfo.UpdateConnection ~= nil, "This ActiveCast has been terminated. It can no longer be used.");
    local v115 = p113.StateInfo.Trajectories[#p113.StateInfo.Trajectories];

    return v115.InitialVelocity + v115.Acceleration * (p113.StateInfo.TotalRuntime - v115.StartTime);
end;

function u1.GetAcceleration(p116) -- Line: 815
    -- upvalues: u1 (copy)
    local v117 = getmetatable(p116) == u1;
    assert(v117, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("GetAcceleration", "ActiveCast.new(...)"));
    assert(p116.StateInfo.UpdateConnection ~= nil, "This ActiveCast has been terminated. It can no longer be used.");

    return p116.StateInfo.Trajectories[#p116.StateInfo.Trajectories].Acceleration;
end;

function u1.GetPosition(p118) -- Line: 822
    -- upvalues: u1 (copy)
    local v119 = getmetatable(p118) == u1;
    assert(v119, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("GetPosition", "ActiveCast.new(...)"));
    assert(p118.StateInfo.UpdateConnection ~= nil, "This ActiveCast has been terminated. It can no longer be used.");
    local v120 = p118.StateInfo.Trajectories[#p118.StateInfo.Trajectories];
    local v121 = p118.StateInfo.TotalRuntime - v120.StartTime;
    local Origin = v120.Origin;
    local InitialVelocity = v120.InitialVelocity;
    local Acceleration = v120.Acceleration;
    local v122 = Vector3.new(Acceleration.X * v121 ^ 2 / 2, Acceleration.Y * v121 ^ 2 / 2, Acceleration.Z * v121 ^ 2 / 2);

    return Origin + InitialVelocity * v121 + v122;
end;

function u1.AddVelocity(p123, p124) -- Line: 836
    -- upvalues: u1 (copy)
    local v125 = getmetatable(p123) == u1;
    assert(v125, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("AddVelocity", "ActiveCast.new(...)"));
    assert(p123.StateInfo.UpdateConnection ~= nil, "This ActiveCast has been terminated. It can no longer be used.");
    p123:SetVelocity(p123:GetVelocity() + p124);
end;

function u1.AddAcceleration(p126, p127) -- Line: 842
    -- upvalues: u1 (copy)
    local v128 = getmetatable(p126) == u1;
    assert(v128, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("AddAcceleration", "ActiveCast.new(...)"));
    assert(p126.StateInfo.UpdateConnection ~= nil, "This ActiveCast has been terminated. It can no longer be used.");
    p126:SetAcceleration(p126:GetAcceleration() + p127);
end;

function u1.AddPosition(p129, p130) -- Line: 848
    -- upvalues: u1 (copy)
    local v131 = getmetatable(p129) == u1;
    assert(v131, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("AddPosition", "ActiveCast.new(...)"));
    assert(p129.StateInfo.UpdateConnection ~= nil, "This ActiveCast has been terminated. It can no longer be used.");
    p129:SetPosition(p129:GetPosition() + p130);
end;

function u1.Pause(p132) -- Line: 856
    -- upvalues: u1 (copy)
    local v133 = getmetatable(p132) == u1;
    assert(v133, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("Pause", "ActiveCast.new(...)"));
    assert(p132.StateInfo.UpdateConnection ~= nil, "This ActiveCast has been terminated. It can no longer be used.");
    p132.StateInfo.Paused = true;
end;

function u1.Resume(p134) -- Line: 862
    -- upvalues: u1 (copy)
    local v135 = getmetatable(p134) == u1;
    assert(v135, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("Resume", "ActiveCast.new(...)"));
    assert(p134.StateInfo.UpdateConnection ~= nil, "This ActiveCast has been terminated. It can no longer be used.");
    p134.StateInfo.Paused = false;
end;

function u1.Terminate(p136) -- Line: 868
    -- upvalues: u1 (copy)
    local v137 = getmetatable(p136) == u1;
    assert(v137, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("Terminate", "ActiveCast.new(...)"));
    assert(p136.StateInfo.UpdateConnection ~= nil, "This ActiveCast has been terminated. It can no longer be used.");
    local Trajectories = p136.StateInfo.Trajectories;
    Trajectories[#Trajectories].EndTime = p136.StateInfo.TotalRuntime;
    p136.StateInfo.UpdateConnection:Disconnect();
    p136.Caster.CastTerminating:FireSync(p136);
    p136.StateInfo.UpdateConnection = nil;
    p136.Caster = nil;
    p136.StateInfo = nil;
    p136.RayInfo = nil;
    p136.UserData = nil;
    setmetatable(p136, nil);
end;

return u1;