-- Decompiled with Potassium's decompiler.

local success, result = pcall(function() -- Line: 10
    return UserSettings():IsUserFeatureEnabled("UserExcludeNonCollidableForPathfinding");
end);
local u1 = success and result;
local success2, result2 = pcall(function() -- Line: 14
    return UserSettings():IsUserFeatureEnabled("UserClickToMoveSupportAgentCanClimb2");
end);
local u2 = success2 and result2;
local UserInputService = game:GetService("UserInputService");
local PathfindingService = game:GetService("PathfindingService");
local Players = game:GetService("Players");
game:GetService("Debris");
local StarterGui = game:GetService("StarterGui");
local Workspace = game:GetService("Workspace");
local CollectionService = game:GetService("CollectionService");
local GuiService = game:GetService("GuiService");
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils");
local u3 = require(CommonUtils:WaitForChild("FlagUtil")).getUserFlag("UserRaycastUpdateAPI");
local u4 = true;
local u5 = true;
local u6 = false;
local u7 = 1;
local u8 = 8;
local u9 = {
    [Enum.KeyCode.W] = true,
    [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true,
    [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true,
    [Enum.KeyCode.Down] = true
};
local LocalPlayer = Players.LocalPlayer;
local ClickToMoveDisplay = require(script.Parent:WaitForChild("ClickToMoveDisplay"));
local u10 = RaycastParams.new();
u10.FilterType = Enum.RaycastFilterType.Exclude;
local u11 = {};

if not u3 then
    local function FindCharacterAncestor(p12) -- Line: 65
        -- upvalues: FindCharacterAncestor (copy)
        if p12 then
            local v13 = p12:FindFirstChildOfClass("Humanoid");

            if v13 then
                return p12, v13;
            end;

            return FindCharacterAncestor(p12.Parent);
        end;
    end;

    u11.FindCharacterAncestor = FindCharacterAncestor;

    local function Raycast(p14, p15, p16) -- Line: 77
        -- upvalues: Workspace (copy), FindCharacterAncestor (copy), Raycast (copy)
        local v17 = p16 or {};
        local v18, v19, v20, v21 = Workspace:FindPartOnRayWithIgnoreList(p14, v17);

        if not v18 then
            return nil, nil;
        end;

        if p15 and v18.CanCollide == false then
            local v22;

            if v18 then
                v22 = v18:FindFirstChildOfClass("Humanoid");

                if not v22 then
                    local v23;
                    v23, v22 = FindCharacterAncestor(v18.Parent);
                end;
            else
                v22 = nil;
            end;

            if v22 == nil then
                table.insert(v17, v18);

                return Raycast(p14, p15, v17);
            end;
        end;

        return v18, v19, v20, v21;
    end;

    u11.Raycast = Raycast;
end;

local u24 = {};

local function findPlayerHumanoid(p25) -- Line: 99
    -- upvalues: u24 (copy)
    local v26;

    if p25 then
        v26 = p25.Character;
    else
        v26 = p25;
    end;

    if v26 then
        local v27 = u24[p25];

        if v27 and v27.Parent == v26 then
            return v27;
        end;

        u24[p25] = nil;
        local v28 = v26:FindFirstChildOfClass("Humanoid");

        if v28 then
            u24[p25] = v28;
        end;

        return v28;
    end;
end;

local u29 = nil;
local u30 = nil;
local u31 = nil;
local u32 = nil;

local function GetCharacter() -- Line: 123
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer and LocalPlayer.Character;
end;

local function UpdateIgnoreTag(p33) -- Line: 127
    -- upvalues: u30 (ref), u31 (ref), u32 (ref), u29 (ref), LocalPlayer (copy), CollectionService (copy)
    if p33 == u30 then
        return;
    end;

    if u31 then
        u31:Disconnect();
        u31 = nil;
    end;

    if u32 then
        u32:Disconnect();
        u32 = nil;
    end;

    u30 = p33;
    local v34 = {};
    v34[1] = LocalPlayer and LocalPlayer.Character;
    u29 = v34;

    if u30 ~= nil then
        local v35 = CollectionService:GetTagged(u30);

        for _, v in ipairs(v35) do
            table.insert(u29, v);
        end;

        u31 = CollectionService:GetInstanceAddedSignal(u30):Connect(function(p36) -- Line: 147
            -- upvalues: u29 (ref)
            table.insert(u29, p36);
        end);
        u32 = CollectionService:GetInstanceRemovedSignal(u30):Connect(function(p37) -- Line: 151
            -- upvalues: u29 (ref)
            for i = 1, #u29 do
                if u29[i] == p37 then
                    u29[i] = u29[#u29];
                    table.remove(u29);

                    return;
                end;
            end;
        end);
    end;
end;

local function getIgnoreList() -- Line: 163
    -- upvalues: u29 (ref), LocalPlayer (copy)
    if u29 then
        return u29;
    end;

    u29 = {};
    assert(u29, "");
    table.insert(u29, LocalPlayer and LocalPlayer.Character);

    return u29;
end;

local function minV(p38, p39) -- Line: 173
    local v40 = math.min(p38.X, p39.X);
    local v41 = math.min(p38.Y, p39.Y);
    local v42 = math.min(p38.Z, p39.Z);

    return Vector3.new(v40, v41, v42);
end;

local function maxV(p43, p44) -- Line: 176
    local v45 = math.max(p43.X, p44.X);
    local v46 = math.max(p43.Y, p44.Y);
    local v47 = math.max(p43.Z, p44.Z);

    return Vector3.new(v45, v46, v47);
end;

local function getCollidableExtentsSize(p48) -- Line: 179
    if p48 ~= nil and p48.PrimaryPart ~= nil then
        assert(p48, "");
        assert(p48.PrimaryPart, "");
        local v49 = p48.PrimaryPart.CFrame:Inverse();
        local v50 = Vector3.new(inf, inf, inf);
        local v51 = Vector3.new(-inf, -inf, -inf);

        for _, descendant in pairs(p48:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant.CanCollide then
                local v52 = v49 * descendant.CFrame;
                local v53 = Vector3.new(descendant.Size.X / 2, descendant.Size.Y / 2, descendant.Size.Z / 2);
                local v54 = {
                    Vector3.new(v53.X, v53.Y, v53.Z),
                    Vector3.new(v53.X, v53.Y, -v53.Z),
                    Vector3.new(v53.X, -v53.Y, v53.Z),
                    Vector3.new(v53.X, -v53.Y, -v53.Z),
                    Vector3.new(-v53.X, v53.Y, v53.Z),
                    Vector3.new(-v53.X, v53.Y, -v53.Z),
                    Vector3.new(-v53.X, -v53.Y, v53.Z),
                    (Vector3.new(-v53.X, -v53.Y, -v53.Z))
                };

                for _, v in ipairs(v54) do
                    local v55 = v52 * v;
                    local v56 = math.min(v50.X, v55.X);
                    local v57 = math.min(v50.Y, v55.Y);
                    local v58 = math.min(v50.Z, v55.Z);
                    v50 = Vector3.new(v56, v57, v58);
                    local v59 = math.max(v51.X, v55.X);
                    local v60 = math.max(v51.Y, v55.Y);
                    local v61 = math.max(v51.Z, v55.Z);
                    v51 = Vector3.new(v59, v60, v61);
                end;
            end;
        end;

        local v62 = v51 - v50;

        if v62.X < 0 or (v62.Y < 0 or v62.Z < 0) then
            return nil;
        end;

        return v62;
    end;
end;

local function Pather(p63, p64, p65) -- Line: 214
    -- upvalues: u6 (ref), LocalPlayer (copy), u24 (copy), u7 (ref), u1 (copy), getCollidableExtentsSize (copy), u2 (copy), PathfindingService (copy), u4 (ref), ClickToMoveDisplay (copy), u8 (ref), u3 (copy), u10 (copy), u29 (ref), Workspace (copy)
    local u66 = {};
    local v67;

    if p65 == nil then
        v67 = u6;
        p65 = true;
    else
        v67 = p65;
    end;

    u66.Cancelled = false;
    u66.Started = false;
    u66.Finished = Instance.new("BindableEvent");
    u66.PathFailed = Instance.new("BindableEvent");
    u66.PathComputing = false;
    u66.PathComputed = false;
    u66.OriginalTargetPoint = p63;
    u66.TargetPoint = p63;
    u66.TargetSurfaceNormal = p64;
    u66.DiedConn = nil;
    u66.SeatedConn = nil;
    u66.BlockedConn = nil;
    u66.TeleportedConn = nil;
    u66.CurrentPoint = 0;
    u66.HumanoidOffsetFromPath = Vector3.new(0, 0, 0);
    u66.CurrentWaypointPosition = nil;
    u66.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0);
    u66.CurrentWaypointPlaneDistance = 0;
    u66.CurrentWaypointNeedsJump = false;
    u66.CurrentHumanoidPosition = Vector3.new(0, 0, 0);
    u66.CurrentHumanoidVelocity = 0;
    u66.NextActionMoveDirection = Vector3.new(0, 0, 0);
    u66.NextActionJump = false;
    u66.Timeout = 0;
    local v68 = LocalPlayer;
    local v69;

    if v68 then
        v69 = v68.Character;
    else
        v69 = v68;
    end;

    local v70;

    if v69 then
        v70 = u24[v68];

        if not v70 or v70.Parent ~= v69 then
            u24[v68] = nil;
            v70 = v69:FindFirstChildOfClass("Humanoid");

            if v70 then
                u24[v68] = v70;
            end;
        end;
    else
        v70 = nil;
    end;

    u66.Humanoid = v70;
    u66.OriginPoint = nil;
    u66.AgentCanFollowPath = false;
    u66.DirectPath = false;
    u66.DirectPathRiseFirst = false;
    u66.stopTraverseFunc = nil;
    u66.setPointFunc = nil;
    u66.pointList = nil;
    local v71 = u66.Humanoid and u66.Humanoid.RootPart;

    if v71 then
        u66.OriginPoint = v71.CFrame.Position;
        local v72 = 2;
        local v73 = 5;
        local v74 = true;
        local SeatPart = u66.Humanoid.SeatPart;

        if SeatPart and SeatPart:IsA("VehicleSeat") then
            local v75 = SeatPart:FindFirstAncestorOfClass("Model");

            if v75 then
                local PrimaryPart = v75.PrimaryPart;
                v75.PrimaryPart = SeatPart;

                if p65 then
                    local v76 = v75:GetExtentsSize();
                    v72 = u7 * 0.5 * math.sqrt(v76.X * v76.X + v76.Z * v76.Z);
                    v73 = u7 * v76.Y;
                    u66.AgentCanFollowPath = true;
                    u66.DirectPath = p65;
                    v74 = false;
                end;

                v75.PrimaryPart = PrimaryPart;
            end;
        else
            local v77 = nil;

            if u1 then
                local v78 = LocalPlayer and LocalPlayer.Character;

                if v78 ~= nil then
                    v77 = getCollidableExtentsSize(v78);
                end;
            end;

            if v77 == nil then
                v77 = (LocalPlayer and LocalPlayer.Character):GetExtentsSize();
            end;

            assert(v77, "");
            v72 = u7 * 0.5 * math.sqrt(v77.X * v77.X + v77.Z * v77.Z);
            v73 = u7 * v77.Y;
            v74 = u66.Humanoid.JumpPower > 0;
            u66.AgentCanFollowPath = true;
            u66.DirectPath = v67;
            u66.DirectPathRiseFirst = u66.Humanoid.Sit;
        end;

        if u2 then
            u66.pathResult = PathfindingService:CreatePath({
                AgentCanClimb = true,
                AgentRadius = v72,
                AgentHeight = v73,
                AgentCanJump = v74
            });
        else
            u66.pathResult = PathfindingService:CreatePath({
                AgentRadius = v72,
                AgentHeight = v73,
                AgentCanJump = v74
            });
        end;
    end;

    function u66.Cleanup(p79) -- Line: 332
        -- upvalues: u66 (copy)
        if u66.stopTraverseFunc then
            u66.stopTraverseFunc();
            u66.stopTraverseFunc = nil;
        end;

        if u66.BlockedConn then
            u66.BlockedConn:Disconnect();
            u66.BlockedConn = nil;
        end;

        if u66.DiedConn then
            u66.DiedConn:Disconnect();
            u66.DiedConn = nil;
        end;

        if u66.SeatedConn then
            u66.SeatedConn:Disconnect();
            u66.SeatedConn = nil;
        end;

        if u66.TeleportedConn then
            u66.TeleportedConn:Disconnect();
            u66.TeleportedConn = nil;
        end;

        u66.Started = false;
    end;

    function u66.Cancel(p80) -- Line: 361
        -- upvalues: u66 (copy)
        u66.Cancelled = true;
        u66:Cleanup();
    end;

    function u66.IsActive(p81) -- Line: 366
        -- upvalues: u66 (copy)
        return u66.AgentCanFollowPath and u66.Started and not u66.Cancelled;
    end;

    function u66.OnPathInterrupted(p82) -- Line: 370
        -- upvalues: u66 (copy)
        u66.Cancelled = true;
        u66:OnPointReached(false);
    end;

    function u66.ComputePath(p83) -- Line: 376
        -- upvalues: u66 (copy)
        if u66.OriginPoint then
            if u66.PathComputed or u66.PathComputing then
                return;
            end;

            u66.PathComputing = true;

            if u66.AgentCanFollowPath then
                if u66.DirectPath then
                    u66.pointList = { PathWaypoint.new(u66.OriginPoint, Enum.PathWaypointAction.Walk), PathWaypoint.new(u66.TargetPoint, u66.DirectPathRiseFirst and Enum.PathWaypointAction.Jump or Enum.PathWaypointAction.Walk) };
                    u66.PathComputed = true;
                else
                    u66.pathResult:ComputeAsync(u66.OriginPoint, u66.TargetPoint);
                    u66.pointList = u66.pathResult:GetWaypoints();
                    u66.BlockedConn = u66.pathResult.Blocked:Connect(function(p84) -- Line: 390
                        -- upvalues: u66 (ref)
                        u66:OnPathBlocked(p84);
                    end);
                    u66.PathComputed = u66.pathResult.Status == Enum.PathStatus.Success;
                end;
            end;

            u66.PathComputing = false;
        end;
    end;

    function u66.IsValidPath(p85) -- Line: 398
        -- upvalues: u66 (copy)
        u66:ComputePath();

        return u66.PathComputed and u66.AgentCanFollowPath;
    end;

    u66.Recomputing = false;

    function u66.OnPathBlocked(p86, p87) -- Line: 404
        -- upvalues: u66 (copy), u4 (ref), ClickToMoveDisplay (ref)
        if u66.CurrentPoint > p87 or u66.Recomputing then
            return;
        end;

        u66.Recomputing = true;

        if u66.stopTraverseFunc then
            u66.stopTraverseFunc();
            u66.stopTraverseFunc = nil;
        end;

        u66.OriginPoint = u66.Humanoid.RootPart.CFrame.p;
        u66.pathResult:ComputeAsync(u66.OriginPoint, u66.TargetPoint);
        u66.pointList = u66.pathResult:GetWaypoints();

        if #u66.pointList > 0 then
            u66.HumanoidOffsetFromPath = u66.pointList[1].Position - u66.OriginPoint;
        end;

        u66.PathComputed = u66.pathResult.Status == Enum.PathStatus.Success;

        if u4 then
            local v88, v89 = ClickToMoveDisplay.CreatePathDisplay(u66.pointList);
            u66.stopTraverseFunc = v88;
            u66.setPointFunc = v89;
        end;

        if u66.PathComputed then
            u66.CurrentPoint = 1;
            u66:OnPointReached(true);
        else
            u66.PathFailed:Fire();
            u66:Cleanup();
        end;

        u66.Recomputing = false;
    end;

    function u66.OnRenderStepped(p90, p91) -- Line: 440
        -- upvalues: u66 (copy), u8 (ref)
        if u66.Started and not u66.Cancelled then
            u66.Timeout = u66.Timeout + p91;

            if u8 < u66.Timeout then
                u66:OnPointReached(false);

                return;
            end;

            u66.CurrentHumanoidPosition = u66.Humanoid.RootPart.Position + u66.HumanoidOffsetFromPath;
            u66.CurrentHumanoidVelocity = u66.Humanoid.RootPart.Velocity;

            while u66.Started and u66:IsCurrentWaypointReached() do
                u66:OnPointReached(true);
            end;

            if u66.Started then
                u66.NextActionMoveDirection = u66.CurrentWaypointPosition - u66.CurrentHumanoidPosition;

                if u66.NextActionMoveDirection.Magnitude > 1e-6 then
                    u66.NextActionMoveDirection = u66.NextActionMoveDirection.Unit;
                else
                    u66.NextActionMoveDirection = Vector3.new(0, 0, 0);
                end;

                if u66.CurrentWaypointNeedsJump then
                    u66.NextActionJump = true;
                    u66.CurrentWaypointNeedsJump = false;

                    return;
                end;

                u66.NextActionJump = false;
            end;
        end;
    end;

    function u66.IsCurrentWaypointReached(p92) -- Line: 478
        -- upvalues: u66 (copy)
        local v93;

        if u66.CurrentWaypointPlaneNormal == Vector3.new(0, 0, 0) then
            v93 = true;
        else
            local v94 = u66.CurrentWaypointPlaneNormal:Dot(u66.CurrentHumanoidPosition) - u66.CurrentWaypointPlaneDistance;
            local v95 = 0.0625 * -u66.CurrentWaypointPlaneNormal:Dot(u66.CurrentHumanoidVelocity);
            v93 = v94 < math.max(1, v95);
        end;

        if v93 then
            u66.CurrentWaypointPosition = nil;
            u66.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0);
            u66.CurrentWaypointPlaneDistance = 0;
        end;

        return v93;
    end;

    function u66.OnPointReached(p96, p97) -- Line: 504
        -- upvalues: u66 (copy)
        if not p97 or u66.Cancelled then
            u66.PathFailed:Fire();
            u66:Cleanup();

            return;
        end;

        if u66.setPointFunc then
            u66.setPointFunc(u66.CurrentPoint);
        end;

        local v98 = u66.CurrentPoint + 1;

        if #u66.pointList < v98 then
            if u66.stopTraverseFunc then
                u66.stopTraverseFunc();
            end;

            u66.Finished:Fire();
            u66:Cleanup();

            return;
        end;

        local v99 = u66.pointList[u66.CurrentPoint];
        local v100 = u66.pointList[v98];
        local v101 = u66.Humanoid:GetState();

        if (v101 == Enum.HumanoidStateType.FallingDown or v101 == Enum.HumanoidStateType.Freefall) and true or v101 == Enum.HumanoidStateType.Jumping then
            local v102 = v100.Action == Enum.PathWaypointAction.Jump;

            if not v102 and u66.CurrentPoint > 1 then
                local v103 = v99.Position - u66.pointList[u66.CurrentPoint - 1].Position;
                local v104 = v100.Position - v99.Position;
                v102 = Vector2.new(v103.x, v103.z).Unit:Dot(Vector2.new(v104.x, v104.z).Unit) < 0.996;
            end;

            if v102 then
                u66.Humanoid.FreeFalling:Wait();
                wait(0.1);
            end;
        end;

        u66:MoveToNextWayPoint(v99, v100, v98);
    end;

    function u66.MoveToNextWayPoint(p105, p106, p107, p108) -- Line: 567
        -- upvalues: u66 (copy), u2 (ref)
        u66.CurrentWaypointPlaneNormal = p106.Position - p107.Position;

        if not u2 or p107.Label ~= "Climb" then
            u66.CurrentWaypointPlaneNormal = Vector3.new(u66.CurrentWaypointPlaneNormal.X, 0, u66.CurrentWaypointPlaneNormal.Z);
        end;

        if u66.CurrentWaypointPlaneNormal.Magnitude > 1e-6 then
            u66.CurrentWaypointPlaneNormal = u66.CurrentWaypointPlaneNormal.Unit;
            u66.CurrentWaypointPlaneDistance = u66.CurrentWaypointPlaneNormal:Dot(p107.Position);
        else
            u66.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0);
            u66.CurrentWaypointPlaneDistance = 0;
        end;

        u66.CurrentWaypointNeedsJump = p107.Action == Enum.PathWaypointAction.Jump;
        u66.CurrentWaypointPosition = p107.Position;
        u66.CurrentPoint = p108;
        u66.Timeout = 0;
    end;

    function u66.Start(p109, p110) -- Line: 599
        -- upvalues: u66 (copy), ClickToMoveDisplay (ref), u4 (ref)
        if not u66.AgentCanFollowPath then
            u66.PathFailed:Fire();

            return;
        end;

        if u66.Started then
            return;
        end;

        u66.Started = true;
        ClickToMoveDisplay.CancelFailureAnimation();

        if u4 and (p110 == nil or p110) then
            local v111, v112 = ClickToMoveDisplay.CreatePathDisplay(u66.pointList, u66.OriginalTargetPoint);
            u66.stopTraverseFunc = v111;
            u66.setPointFunc = v112;
        end;

        if #u66.pointList <= 0 then
            u66.PathFailed:Fire();

            if u66.stopTraverseFunc then
                u66.stopTraverseFunc();
            end;

            return;
        end;

        u66.HumanoidOffsetFromPath = Vector3.new(0, u66.pointList[1].Position.Y - u66.OriginPoint.Y, 0);
        u66.CurrentHumanoidPosition = u66.Humanoid.RootPart.Position + u66.HumanoidOffsetFromPath;
        u66.CurrentHumanoidVelocity = u66.Humanoid.RootPart.Velocity;
        u66.SeatedConn = u66.Humanoid.Seated:Connect(function(p113, p114) -- Line: 626
            -- upvalues: u66 (ref)
            u66:OnPathInterrupted();
        end);
        u66.DiedConn = u66.Humanoid.Died:Connect(function() -- Line: 627
            -- upvalues: u66 (ref)
            u66:OnPathInterrupted();
        end);
        u66.TeleportedConn = u66.Humanoid.RootPart:GetPropertyChangedSignal("CFrame"):Connect(function() -- Line: 628
            -- upvalues: u66 (ref)
            u66:OnPathInterrupted();
        end);
        u66.CurrentPoint = 1;
        u66:OnPointReached(true);
    end;

    local v115 = u66.TargetPoint + u66.TargetSurfaceNormal * 1.5;

    if u3 then
        local v116;

        if u29 then
            v116 = u29;
        else
            u29 = {};
            assert(u29, "");
            table.insert(u29, LocalPlayer and LocalPlayer.Character);
            v116 = u29;
        end;

        u10.FilterDescendantsInstances = v116;
        local v117 = Workspace:Raycast(v115, Vector3.new(-0, -50, -0), u10);

        if v117 then
            u66.TargetPoint = v117.Position;
        end;
    else
        local v118 = Ray.new(v115, Vector3.new(0, -50, 0));
        local v119;

        if u29 then
            v119 = u29;
        else
            u29 = {};
            assert(u29, "");
            table.insert(u29, LocalPlayer and LocalPlayer.Character);
            v119 = u29;
        end;

        local v120, v121 = Workspace:FindPartOnRayWithIgnoreList(v118, v119);

        if v120 then
            u66.TargetPoint = v121;
        end;
    end;

    u66:ComputePath();

    return u66;
end;

local function CheckAlive() -- Line: 664
    -- upvalues: LocalPlayer (copy), u24 (copy)
    local v122 = LocalPlayer;
    local v123;

    if v122 then
        v123 = v122.Character;
    else
        v123 = v122;
    end;

    local v124;

    if v123 then
        v124 = u24[v122];

        if not v124 or v124.Parent ~= v123 then
            u24[v122] = nil;
            v124 = v123:FindFirstChildOfClass("Humanoid");

            if v124 then
                u24[v122] = v124;
            end;
        end;
    else
        v124 = nil;
    end;

    local v125;

    if v124 == nil then
        v125 = false;
    else
        v125 = v124.Health > 0;
    end;

    return v125;
end;

local function GetEquippedTool(p126) -- Line: 669
    if p126 ~= nil then
        for _, child in pairs(p126:GetChildren()) do
            if child:IsA("Tool") then
                return child;
            end;
        end;
    end;
end;

local u127 = nil;
local u128 = nil;
local u129 = nil;

local function CleanupPath() -- Line: 684
    -- upvalues: u127 (ref), u128 (ref), u129 (ref)
    if u127 then
        u127:Cancel();
        u127 = nil;
    end;

    if u128 then
        u128:Disconnect();
        u128 = nil;
    end;

    if u129 then
        u129:Disconnect();
        u129 = nil;
    end;
end;

local function HandleMoveTo(p130, u131, u132, u133, u134) -- Line: 702
    -- upvalues: u127 (ref), u128 (ref), u129 (ref), GetEquippedTool (copy), u5 (ref), ClickToMoveDisplay (copy)
    if u127 then
        if u127 then
            u127:Cancel();
            u127 = nil;
        end;

        if u128 then
            u128:Disconnect();
            u128 = nil;
        end;

        if u129 then
            u129:Disconnect();
            u129 = nil;
        end;
    end;

    u127 = p130;
    p130:Start(u134);
    u128 = p130.Finished.Event:Connect(function() -- Line: 709
        -- upvalues: u127 (ref), u128 (ref), u129 (ref), u132 (copy), GetEquippedTool (ref), u133 (copy)
        if u127 then
            u127:Cancel();
            u127 = nil;
        end;

        if u128 then
            u128:Disconnect();
            u128 = nil;
        end;

        if u129 then
            u129:Disconnect();
            u129 = nil;
        end;

        local v135 = u132 and GetEquippedTool(u133);

        if v135 then
            v135:Activate();
        end;
    end);
    u129 = p130.PathFailed.Event:Connect(function() -- Line: 718
        -- upvalues: u127 (ref), u128 (ref), u129 (ref), u134 (copy), u5 (ref), ClickToMoveDisplay (ref), u131 (copy)
        if u127 then
            u127:Cancel();
            u127 = nil;
        end;

        if u128 then
            u128:Disconnect();
            u128 = nil;
        end;

        if u129 then
            u129:Disconnect();
            u129 = nil;
        end;

        if u134 == nil or u134 then
            local v136 = u5;

            if v136 then
                local v137 = u127 and u127:IsActive();
                v136 = not v137;
            end;

            if v136 then
                ClickToMoveDisplay.PlayFailureAnimation();
            end;

            ClickToMoveDisplay.DisplayFailureWaypoint(u131);
        end;
    end);
end;

local function ShowPathFailedFeedback(p138) -- Line: 730
    -- upvalues: u127 (ref), u5 (ref), ClickToMoveDisplay (copy)
    if u127 and u127:IsActive() then
        u127:Cancel();
    end;

    if u5 then
        ClickToMoveDisplay.PlayFailureAnimation();
    end;

    ClickToMoveDisplay.DisplayFailureWaypoint(p138);
end;

function OnTap(p139, p140, p141)
    -- upvalues: Workspace (copy), LocalPlayer (copy), u24 (copy), u3 (copy), u29 (ref), u10 (copy), StarterGui (copy), Players (copy), u127 (ref), u128 (ref), u129 (ref), Pather (copy), HandleMoveTo (copy), u5 (ref), ClickToMoveDisplay (copy), u11 (copy), GetEquippedTool (copy)
    local CurrentCamera = Workspace.CurrentCamera;
    local Character = LocalPlayer.Character;
    local v142 = LocalPlayer;
    local v143;

    if v142 then
        v143 = v142.Character;
    else
        v143 = v142;
    end;

    local v144;

    if v143 then
        v144 = u24[v142];

        if not v144 or v144.Parent ~= v143 then
            u24[v142] = nil;
            v144 = v143:FindFirstChildOfClass("Humanoid");

            if v144 then
                u24[v142] = v144;
            end;
        end;
    else
        v144 = nil;
    end;

    local v145;

    if v144 == nil then
        v145 = false;
    else
        v145 = v144.Health > 0;
    end;

    if not v145 then
        return;
    end;

    if #p139 ~= 1 and not p140 then
        local v146 = #p139 >= 2 and (CurrentCamera and GetEquippedTool(Character));

        if v146 then
            v146:Activate();
        end;

        return;
    end;

    if not CurrentCamera then
        return;
    end;

    local v147 = CurrentCamera:ScreenPointToRay(p139[1].X, p139[1].Y);

    if not u3 then
        local v148 = Ray.new(v147.Origin, v147.Direction * 1000);
        local Raycast = u11.Raycast;
        local v149;

        if u29 then
            v149 = u29;
        else
            u29 = {};
            assert(u29, "");
            table.insert(u29, LocalPlayer and LocalPlayer.Character);
            v149 = u29;
        end;

        local v150, v151, v152 = Raycast(v148, true, v149);
        local v153, v154 = u11.FindCharacterAncestor(v150);

        if p141 and (v154 and (StarterGui:GetCore("AvatarContextMenuEnabled") and Players:GetPlayerFromCharacter(v154.Parent))) then
            if u127 then
                u127:Cancel();
                u127 = nil;
            end;

            if u128 then
                u128:Disconnect();
                u128 = nil;
            end;

            if u129 then
                u129:Disconnect();
                u129 = nil;
            end;

            return;
        end;

        if p140 then
            v153 = nil;
        else
            p140 = v151;
        end;

        if p140 and Character then
            if u127 then
                u127:Cancel();
                u127 = nil;
            end;

            if u128 then
                u128:Disconnect();
                u128 = nil;
            end;

            if u129 then
                u129:Disconnect();
                u129 = nil;
            end;

            local v155 = Pather(p140, v152);

            if v155:IsValidPath() then
                HandleMoveTo(v155, p140, v153, Character);

                return;
            end;

            v155:Cleanup();

            if u127 and u127:IsActive() then
                u127:Cancel();
            end;

            if u5 then
                ClickToMoveDisplay.PlayFailureAnimation();
            end;

            ClickToMoveDisplay.DisplayFailureWaypoint(p140);

            return;
        end;

        return;
    end;

    local v156 = nil;
    local v157 = nil;
    local v158;

    if u29 then
        v158 = u29;
    else
        u29 = {};
        assert(u29, "");
        table.insert(u29, LocalPlayer and LocalPlayer.Character);
        v158 = u29;
    end;

    if not v158 then
        v158 = {};
    end;

    while true do
        local v159 = true;
        u10.FilterDescendantsInstances = v158;
        local v160 = Workspace:Raycast(v147.Origin, v147.Direction * 1000, u10);
        local v161, v162;

        if v160 then
            local Instance2 = v160.Instance;

            if not Instance2.CanCollide then
                local v163;

                while true do
                    v156 = Instance2:FindFirstChildOfClass("Humanoid");
                    v163 = Instance2.Parent;

                    if v156 or (not v163 or v163 == Workspace) then
                        break;
                    end;

                    Instance2 = v163;
                end;

                if v156 then
                    v157 = Instance2;
                else
                    table.insert(v158, v163);
                    v159 = false;
                    v157 = nil;
                end;

                if v159 then
                    if p141 and (v156 and (StarterGui:GetCore("AvatarContextMenuEnabled") and Players:GetPlayerFromCharacter(v156.Parent))) then
                        if u127 then
                            u127:Cancel();
                            u127 = nil;
                        end;

                        if u128 then
                            u128:Disconnect();
                            u128 = nil;
                        end;

                        if u129 then
                            u129:Disconnect();
                            u129 = nil;
                        end;

                        return;
                    end;

                    if not (v160 and Character) then
                        return;
                    end;

                    v161 = v160.Position;

                    if p140 then
                        v157 = nil;
                    else
                        p140 = v161;
                    end;

                    if u127 then
                        u127:Cancel();
                        u127 = nil;
                    end;

                    if u128 then
                        u128:Disconnect();
                        u128 = nil;
                    end;

                    if u129 then
                        u129:Disconnect();
                        u129 = nil;
                    end;

                    v162 = Pather(p140, v160.Normal);

                    if v162:IsValidPath() then
                        HandleMoveTo(v162, p140, v157, Character);

                        return;
                    end;

                    v162:Cleanup();

                    if u127 and u127:IsActive() then
                        u127:Cancel();
                    end;

                    if u5 then
                        ClickToMoveDisplay.PlayFailureAnimation();
                    end;

                    ClickToMoveDisplay.DisplayFailureWaypoint(p140);

                    return;
                end;
            end;
        end;

        if v159 then
            if p141 and (v156 and (StarterGui:GetCore("AvatarContextMenuEnabled") and Players:GetPlayerFromCharacter(v156.Parent))) then
                if u127 then
                    u127:Cancel();
                    u127 = nil;
                end;

                if u128 then
                    u128:Disconnect();
                    u128 = nil;
                end;

                if u129 then
                    u129:Disconnect();
                    u129 = nil;
                end;

                return;
            end;

            if not (v160 and Character) then
                return;
            end;

            v161 = v160.Position;

            if p140 then
                v157 = nil;
            else
                p140 = v161;
            end;

            if u127 then
                u127:Cancel();
                u127 = nil;
            end;

            if u128 then
                u128:Disconnect();
                u128 = nil;
            end;

            if u129 then
                u129:Disconnect();
                u129 = nil;
            end;

            v162 = Pather(p140, v160.Normal);

            if v162:IsValidPath() then
                HandleMoveTo(v162, p140, v157, Character);

                return;
            end;

            v162:Cleanup();

            if u127 and u127:IsActive() then
                u127:Cancel();
            end;

            if u5 then
                ClickToMoveDisplay.PlayFailureAnimation();
            end;

            ClickToMoveDisplay.DisplayFailureWaypoint(p140);

            return;
        end;
    end;
end;

local function DisconnectEvent(p164) -- Line: 850
    if p164 then
        p164:Disconnect();
    end;
end;

local Keyboard = require(script.Parent:WaitForChild("Keyboard"));
local u165 = setmetatable({}, Keyboard);
u165.__index = u165;

function u165.new(p166) -- Line: 861
    -- upvalues: Keyboard (copy), u165 (copy)
    local v167 = Keyboard.new(p166);
    local v168 = setmetatable(v167, u165);
    v168.fingerTouches = {};
    v168.numUnsunkTouches = 0;
    v168.mouse1Down = tick();
    v168.mouse1DownPos = Vector2.new();
    v168.mouse2DownTime = tick();
    v168.mouse2DownPos = Vector2.new();
    v168.mouse2UpTime = tick();
    v168.keyboardMoveVector = Vector3.new(0, 0, 0);
    v168.tapConn = nil;
    v168.inputBeganConn = nil;
    v168.inputChangedConn = nil;
    v168.inputEndedConn = nil;
    v168.humanoidDiedConn = nil;
    v168.characterChildAddedConn = nil;
    v168.onCharacterAddedConn = nil;
    v168.characterChildRemovedConn = nil;
    v168.renderSteppedConn = nil;
    v168.menuOpenedConnection = nil;
    v168.running = false;
    v168.wasdEnabled = false;

    return v168;
end;

function u165.DisconnectEvents(p169) -- Line: 893
    local tapConn = p169.tapConn;

    if tapConn then
        tapConn:Disconnect();
    end;

    local inputBeganConn = p169.inputBeganConn;

    if inputBeganConn then
        inputBeganConn:Disconnect();
    end;

    local inputChangedConn = p169.inputChangedConn;

    if inputChangedConn then
        inputChangedConn:Disconnect();
    end;

    local inputEndedConn = p169.inputEndedConn;

    if inputEndedConn then
        inputEndedConn:Disconnect();
    end;

    local humanoidDiedConn = p169.humanoidDiedConn;

    if humanoidDiedConn then
        humanoidDiedConn:Disconnect();
    end;

    local characterChildAddedConn = p169.characterChildAddedConn;

    if characterChildAddedConn then
        characterChildAddedConn:Disconnect();
    end;

    local onCharacterAddedConn = p169.onCharacterAddedConn;

    if onCharacterAddedConn then
        onCharacterAddedConn:Disconnect();
    end;

    local renderSteppedConn = p169.renderSteppedConn;

    if renderSteppedConn then
        renderSteppedConn:Disconnect();
    end;

    local characterChildRemovedConn = p169.characterChildRemovedConn;

    if characterChildRemovedConn then
        characterChildRemovedConn:Disconnect();
    end;

    local menuOpenedConnection = p169.menuOpenedConnection;

    if menuOpenedConnection then
        menuOpenedConnection:Disconnect();
    end;
end;

function u165.OnTouchBegan(p170, p171, p172) -- Line: 906
    if p170.fingerTouches[p171] == nil and not p172 then
        p170.numUnsunkTouches = p170.numUnsunkTouches + 1;
    end;

    p170.fingerTouches[p171] = p172;
end;

function u165.OnTouchChanged(p173, p174, p175) -- Line: 913
    if p173.fingerTouches[p174] == nil then
        p173.fingerTouches[p174] = p175;

        if not p175 then
            p173.numUnsunkTouches = p173.numUnsunkTouches + 1;
        end;
    end;
end;

function u165.OnTouchEnded(p176, p177, p178) -- Line: 922
    if p176.fingerTouches[p177] ~= nil and p176.fingerTouches[p177] == false then
        p176.numUnsunkTouches = p176.numUnsunkTouches - 1;
    end;

    p176.fingerTouches[p177] = nil;
end;

function u165.OnCharacterAdded(u179, p180) -- Line: 930
    -- upvalues: UserInputService (copy), u9 (copy), u127 (ref), u128 (ref), u129 (ref), ClickToMoveDisplay (copy), GuiService (copy)
    u179:DisconnectEvents();
    u179.inputBeganConn = UserInputService.InputBegan:Connect(function(p181, p182) -- Line: 933
        -- upvalues: u179 (copy), u9 (ref), u127 (ref), u128 (ref), u129 (ref), ClickToMoveDisplay (ref)
        if p181.UserInputType == Enum.UserInputType.Touch then
            u179:OnTouchBegan(p181, p182);
        end;

        if u179.wasdEnabled and (p182 == false and (p181.UserInputType == Enum.UserInputType.Keyboard and u9[p181.KeyCode])) then
            if u127 then
                u127:Cancel();
                u127 = nil;
            end;

            if u128 then
                u128:Disconnect();
                u128 = nil;
            end;

            if u129 then
                u129:Disconnect();
                u129 = nil;
            end;

            ClickToMoveDisplay.CancelFailureAnimation();
        end;

        if p181.UserInputType == Enum.UserInputType.MouseButton1 then
            u179.mouse1DownTime = tick();
            u179.mouse1DownPos = p181.Position;
        end;

        if p181.UserInputType == Enum.UserInputType.MouseButton2 then
            u179.mouse2DownTime = tick();
            u179.mouse2DownPos = p181.Position;
        end;
    end);
    u179.inputChangedConn = UserInputService.InputChanged:Connect(function(p183, p184) -- Line: 954
        -- upvalues: u179 (copy)
        if p183.UserInputType == Enum.UserInputType.Touch then
            u179:OnTouchChanged(p183, p184);
        end;
    end);
    u179.inputEndedConn = UserInputService.InputEnded:Connect(function(p185, p186) -- Line: 960
        -- upvalues: u179 (copy), u127 (ref)
        if p185.UserInputType == Enum.UserInputType.Touch then
            u179:OnTouchEnded(p185, p186);
        end;

        if p185.UserInputType == Enum.UserInputType.MouseButton2 then
            u179.mouse2UpTime = tick();
            local Position = p185.Position;

            if u179.mouse2UpTime - u179.mouse2DownTime < 0.25 and ((Position - u179.mouse2DownPos).magnitude < 5 and (u127 or u179.keyboardMoveVector.Magnitude <= 0)) then
                OnTap({ Position });
            end;
        end;
    end);
    u179.tapConn = UserInputService.TouchTap:Connect(function(p187, p188) -- Line: 977
        if not p188 then
            OnTap(p187, nil, true);
        end;
    end);
    u179.menuOpenedConnection = GuiService.MenuOpened:Connect(function() -- Line: 983
        -- upvalues: u127 (ref), u128 (ref), u129 (ref)
        if u127 then
            u127:Cancel();
            u127 = nil;
        end;

        if u128 then
            u128:Disconnect();
            u128 = nil;
        end;

        if u129 then
            u129:Disconnect();
            u129 = nil;
        end;
    end);

    local function OnCharacterChildAdded(p189) -- Line: 987
        -- upvalues: UserInputService (ref), u179 (copy)
        if UserInputService.TouchEnabled and p189:IsA("Tool") then
            p189.ManualActivationOnly = true;
        end;

        if p189:IsA("Humanoid") then
            local humanoidDiedConn = u179.humanoidDiedConn;

            if humanoidDiedConn then
                humanoidDiedConn:Disconnect();
            end;

            u179.humanoidDiedConn = p189.Died:Connect(function() -- Line: 995
            end);
        end;
    end;

    u179.characterChildAddedConn = p180.ChildAdded:Connect(function(p190) -- Line: 1003
        -- upvalues: OnCharacterChildAdded (copy)
        OnCharacterChildAdded(p190);
    end);
    u179.characterChildRemovedConn = p180.ChildRemoved:Connect(function(p191) -- Line: 1006
        -- upvalues: UserInputService (ref)
        if UserInputService.TouchEnabled and p191:IsA("Tool") then
            p191.ManualActivationOnly = false;
        end;
    end);

    for _, child in pairs(p180:GetChildren()) do
        OnCharacterChildAdded(child);
    end;
end;

function u165.Start(p192) -- Line: 1018
    p192:Enable(true);
end;

function u165.Stop(p193) -- Line: 1022
    p193:Enable(false);
end;

function u165.CleanupPath(p194) -- Line: 1026
    -- upvalues: u127 (ref), u128 (ref), u129 (ref)
    if u127 then
        u127:Cancel();
        u127 = nil;
    end;

    if u128 then
        u128:Disconnect();
        u128 = nil;
    end;

    if u129 then
        u129:Disconnect();
        u129 = nil;
    end;
end;

function u165.Enable(u195, p196, p197, p198) -- Line: 1030
    -- upvalues: LocalPlayer (copy), u127 (ref), u128 (ref), u129 (ref), UserInputService (copy), Keyboard (copy)
    if p196 then
        if not u195.running then
            if LocalPlayer.Character then
                u195:OnCharacterAdded(LocalPlayer.Character);
            end;

            u195.onCharacterAddedConn = LocalPlayer.CharacterAdded:Connect(function(p199) -- Line: 1036
                -- upvalues: u195 (copy)
                u195:OnCharacterAdded(p199);
            end);
            u195.running = true;
        end;

        u195.touchJumpController = p198;

        if u195.touchJumpController then
            u195.touchJumpController:Enable(u195.jumpEnabled);
        end;
    else
        if u195.running then
            u195:DisconnectEvents();

            if u127 then
                u127:Cancel();
                u127 = nil;
            end;

            if u128 then
                u128:Disconnect();
                u128 = nil;
            end;

            if u129 then
                u129:Disconnect();
                u129 = nil;
            end;

            if UserInputService.TouchEnabled then
                local Character = LocalPlayer.Character;

                if Character then
                    for _, child in pairs(Character:GetChildren()) do
                        if child:IsA("Tool") then
                            child.ManualActivationOnly = false;
                        end;
                    end;
                end;
            end;

            u195.running = false;
        end;

        if u195.touchJumpController and not u195.jumpEnabled then
            u195.touchJumpController:Enable(true);
        end;

        u195.touchJumpController = nil;
    end;

    Keyboard.Enable(u195, p196);
    u195.wasdEnabled = p196 and p197 and p197 or false;
    u195.enabled = p196;
end;

function u165.OnRenderStepped(p200, p201) -- Line: 1075
    -- upvalues: u127 (ref)
    p200.isJumping = false;

    if u127 then
        u127:OnRenderStepped(p201);

        if u127 then
            p200.moveVector = u127.NextActionMoveDirection;
            p200.moveVectorIsCameraRelative = false;

            if u127.NextActionJump then
                p200.isJumping = true;
            end;
        else
            p200.moveVector = p200.keyboardMoveVector;
            p200.moveVectorIsCameraRelative = true;
        end;
    else
        p200.moveVector = p200.keyboardMoveVector;
        p200.moveVectorIsCameraRelative = true;
    end;

    if p200.jumpRequested then
        p200.isJumping = true;
    end;
end;

function u165.UpdateMovement(p202, p203) -- Line: 1110
    if p203 == Enum.UserInputState.Cancel then
        p202.keyboardMoveVector = Vector3.new(0, 0, 0);

        return;
    end;

    if p202.wasdEnabled then
        p202.keyboardMoveVector = Vector3.new(p202.leftValue + p202.rightValue, 0, p202.forwardValue + p202.backwardValue);
    end;
end;

function u165.UpdateJump(p204) -- Line: 1119
end;

function u165.SetShowPath(p205, p206) -- Line: 1124
    -- upvalues: u4 (ref)
    u4 = p206;
end;

function u165.GetShowPath(p207) -- Line: 1128
    -- upvalues: u4 (ref)
    return u4;
end;

function u165.SetWaypointTexture(p208, p209) -- Line: 1132
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetWaypointTexture(p209);
end;

function u165.GetWaypointTexture(p210) -- Line: 1136
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetWaypointTexture();
end;

function u165.SetWaypointRadius(p211, p212) -- Line: 1140
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetWaypointRadius(p212);
end;

function u165.GetWaypointRadius(p213) -- Line: 1144
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetWaypointRadius();
end;

function u165.SetEndWaypointTexture(p214, p215) -- Line: 1148
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetEndWaypointTexture(p215);
end;

function u165.GetEndWaypointTexture(p216) -- Line: 1152
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetEndWaypointTexture();
end;

function u165.SetWaypointsAlwaysOnTop(p217, p218) -- Line: 1156
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetWaypointsAlwaysOnTop(p218);
end;

function u165.GetWaypointsAlwaysOnTop(p219) -- Line: 1160
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetWaypointsAlwaysOnTop();
end;

function u165.SetFailureAnimationEnabled(p220, p221) -- Line: 1164
    -- upvalues: u5 (ref)
    u5 = p221;
end;

function u165.GetFailureAnimationEnabled(p222) -- Line: 1168
    -- upvalues: u5 (ref)
    return u5;
end;

function u165.SetIgnoredPartsTag(p223, p224) -- Line: 1172
    -- upvalues: UpdateIgnoreTag (copy)
    UpdateIgnoreTag(p224);
end;

function u165.GetIgnoredPartsTag(p225) -- Line: 1176
    -- upvalues: u30 (ref)
    return u30;
end;

function u165.SetUseDirectPath(p226, p227) -- Line: 1180
    -- upvalues: u6 (ref)
    u6 = p227;
end;

function u165.GetUseDirectPath(p228) -- Line: 1184
    -- upvalues: u6 (ref)
    return u6;
end;

function u165.SetAgentSizeIncreaseFactor(p229, p230) -- Line: 1188
    -- upvalues: u7 (ref)
    u7 = p230 / 100 + 1;
end;

function u165.GetAgentSizeIncreaseFactor(p231) -- Line: 1192
    -- upvalues: u7 (ref)
    return (u7 - 1) * 100;
end;

function u165.SetUnreachableWaypointTimeout(p232, p233) -- Line: 1196
    -- upvalues: u8 (ref)
    u8 = p233;
end;

function u165.GetUnreachableWaypointTimeout(p234) -- Line: 1200
    -- upvalues: u8 (ref)
    return u8;
end;

function u165.SetUserJumpEnabled(p235, p236) -- Line: 1204
    p235.jumpEnabled = p236;

    if p235.touchJumpController then
        p235.touchJumpController:Enable(p236);
    end;
end;

function u165.GetUserJumpEnabled(p237) -- Line: 1211
    return p237.jumpEnabled;
end;

function u165.MoveTo(p238, p239, p240, p241) -- Line: 1215
    -- upvalues: LocalPlayer (copy), Pather (copy), HandleMoveTo (copy)
    local Character = LocalPlayer.Character;

    if Character == nil then
        return false;
    end;

    local v242 = Pather(p239, Vector3.new(0, 1, 0), p241);

    if not (v242 and v242:IsValidPath()) then
        return false;
    end;

    HandleMoveTo(v242, p239, nil, Character, p240);

    return true;
end;

return u165;