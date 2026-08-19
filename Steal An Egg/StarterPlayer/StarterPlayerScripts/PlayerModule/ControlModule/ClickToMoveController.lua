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
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"));
local u3 = FlagUtil.getUserFlag("UserRaycastUpdateAPI");
local u4 = FlagUtil.getUserFlag("UserPreferredInputPlayerScripts2");
local u5 = true;
local u6 = true;
local u7 = false;
local u8 = 1;
local u9 = 8;
local u10 = {
    [Enum.KeyCode.W] = true,
    [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true,
    [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true,
    [Enum.KeyCode.Down] = true
};
local LocalPlayer = Players.LocalPlayer;
local ClickToMoveDisplay = require(script.Parent:WaitForChild("ClickToMoveDisplay"));
local u11 = RaycastParams.new();
u11.FilterType = Enum.RaycastFilterType.Exclude;
local u12 = {};

if not u3 then
    local function FindCharacterAncestor(p13) -- Line: 66
        -- upvalues: FindCharacterAncestor (copy)
        if p13 then
            local v14 = p13:FindFirstChildOfClass("Humanoid");

            if v14 then
                return p13, v14;
            end;

            return FindCharacterAncestor(p13.Parent);
        end;
    end;

    u12.FindCharacterAncestor = FindCharacterAncestor;

    local function Raycast(p15, p16, p17) -- Line: 78
        -- upvalues: Workspace (copy), FindCharacterAncestor (copy), Raycast (copy)
        local v18 = p17 or {};
        local v19, v20, v21, v22 = Workspace:FindPartOnRayWithIgnoreList(p15, v18);

        if not v19 then
            return nil, nil;
        end;

        if p16 and v19.CanCollide == false then
            local v23;

            if v19 then
                v23 = v19:FindFirstChildOfClass("Humanoid");

                if not v23 then
                    local v24;
                    v24, v23 = FindCharacterAncestor(v19.Parent);
                end;
            else
                v23 = nil;
            end;

            if v23 == nil then
                table.insert(v18, v19);

                return Raycast(p15, p16, v18);
            end;
        end;

        return v19, v20, v21, v22;
    end;

    u12.Raycast = Raycast;
end;

local u25 = {};

local function findPlayerHumanoid(p26) -- Line: 100
    -- upvalues: u25 (copy)
    local v27;

    if p26 then
        v27 = p26.Character;
    else
        v27 = p26;
    end;

    if v27 then
        local v28 = u25[p26];

        if v28 and v28.Parent == v27 then
            return v28;
        end;

        u25[p26] = nil;
        local v29 = v27:FindFirstChildOfClass("Humanoid");

        if v29 then
            u25[p26] = v29;
        end;

        return v29;
    end;
end;

local u30 = nil;
local u31 = nil;
local u32 = nil;
local u33 = nil;

local function GetCharacter() -- Line: 124
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer and LocalPlayer.Character;
end;

local function UpdateIgnoreTag(p34) -- Line: 128
    -- upvalues: u31 (ref), u32 (ref), u33 (ref), u30 (ref), LocalPlayer (copy), CollectionService (copy)
    if p34 == u31 then
        return;
    end;

    if u32 then
        u32:Disconnect();
        u32 = nil;
    end;

    if u33 then
        u33:Disconnect();
        u33 = nil;
    end;

    u31 = p34;
    local v35 = {};
    v35[1] = LocalPlayer and LocalPlayer.Character;
    u30 = v35;

    if u31 ~= nil then
        local v36 = CollectionService:GetTagged(u31);

        for _, v in ipairs(v36) do
            table.insert(u30, v);
        end;

        u32 = CollectionService:GetInstanceAddedSignal(u31):Connect(function(p37) -- Line: 148
            -- upvalues: u30 (ref)
            table.insert(u30, p37);
        end);
        u33 = CollectionService:GetInstanceRemovedSignal(u31):Connect(function(p38) -- Line: 152
            -- upvalues: u30 (ref)
            for i = 1, #u30 do
                if u30[i] == p38 then
                    u30[i] = u30[#u30];
                    table.remove(u30);

                    return;
                end;
            end;
        end);
    end;
end;

local function getIgnoreList() -- Line: 164
    -- upvalues: u30 (ref), LocalPlayer (copy)
    if u30 then
        return u30;
    end;

    u30 = {};
    assert(u30, "");
    table.insert(u30, LocalPlayer and LocalPlayer.Character);

    return u30;
end;

local function minV(p39, p40) -- Line: 174
    local v41 = math.min(p39.X, p40.X);
    local v42 = math.min(p39.Y, p40.Y);
    local v43 = math.min(p39.Z, p40.Z);

    return Vector3.new(v41, v42, v43);
end;

local function maxV(p44, p45) -- Line: 177
    local v46 = math.max(p44.X, p45.X);
    local v47 = math.max(p44.Y, p45.Y);
    local v48 = math.max(p44.Z, p45.Z);

    return Vector3.new(v46, v47, v48);
end;

local function getCollidableExtentsSize(p49) -- Line: 180
    if p49 ~= nil and p49.PrimaryPart ~= nil then
        assert(p49, "");
        assert(p49.PrimaryPart, "");
        local v50 = p49.PrimaryPart.CFrame:Inverse();
        local v51 = Vector3.new(inf, inf, inf);
        local v52 = Vector3.new(-inf, -inf, -inf);

        for _, descendant in pairs(p49:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant.CanCollide then
                local v53 = v50 * descendant.CFrame;
                local v54 = Vector3.new(descendant.Size.X / 2, descendant.Size.Y / 2, descendant.Size.Z / 2);
                local v55 = {
                    Vector3.new(v54.X, v54.Y, v54.Z),
                    Vector3.new(v54.X, v54.Y, -v54.Z),
                    Vector3.new(v54.X, -v54.Y, v54.Z),
                    Vector3.new(v54.X, -v54.Y, -v54.Z),
                    Vector3.new(-v54.X, v54.Y, v54.Z),
                    Vector3.new(-v54.X, v54.Y, -v54.Z),
                    Vector3.new(-v54.X, -v54.Y, v54.Z),
                    (Vector3.new(-v54.X, -v54.Y, -v54.Z))
                };

                for _, v in ipairs(v55) do
                    local v56 = v53 * v;
                    local v57 = math.min(v51.X, v56.X);
                    local v58 = math.min(v51.Y, v56.Y);
                    local v59 = math.min(v51.Z, v56.Z);
                    v51 = Vector3.new(v57, v58, v59);
                    local v60 = math.max(v52.X, v56.X);
                    local v61 = math.max(v52.Y, v56.Y);
                    local v62 = math.max(v52.Z, v56.Z);
                    v52 = Vector3.new(v60, v61, v62);
                end;
            end;
        end;

        local v63 = v52 - v51;

        if v63.X < 0 or (v63.Y < 0 or v63.Z < 0) then
            return nil;
        end;

        return v63;
    end;
end;

local function Pather(p64, p65, p66) -- Line: 215
    -- upvalues: u7 (ref), LocalPlayer (copy), u25 (copy), u8 (ref), u1 (copy), getCollidableExtentsSize (copy), u2 (copy), PathfindingService (copy), u5 (ref), ClickToMoveDisplay (copy), u9 (ref), u3 (copy), u11 (copy), u30 (ref), Workspace (copy)
    local u67 = {};
    local v68;

    if p66 == nil then
        v68 = u7;
        p66 = true;
    else
        v68 = p66;
    end;

    u67.Cancelled = false;
    u67.Started = false;
    u67.Finished = Instance.new("BindableEvent");
    u67.PathFailed = Instance.new("BindableEvent");
    u67.PathComputing = false;
    u67.PathComputed = false;
    u67.OriginalTargetPoint = p64;
    u67.TargetPoint = p64;
    u67.TargetSurfaceNormal = p65;
    u67.DiedConn = nil;
    u67.SeatedConn = nil;
    u67.BlockedConn = nil;
    u67.TeleportedConn = nil;
    u67.CurrentPoint = 0;
    u67.HumanoidOffsetFromPath = Vector3.new(0, 0, 0);
    u67.CurrentWaypointPosition = nil;
    u67.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0);
    u67.CurrentWaypointPlaneDistance = 0;
    u67.CurrentWaypointNeedsJump = false;
    u67.CurrentHumanoidPosition = Vector3.new(0, 0, 0);
    u67.CurrentHumanoidVelocity = 0;
    u67.NextActionMoveDirection = Vector3.new(0, 0, 0);
    u67.NextActionJump = false;
    u67.Timeout = 0;
    local v69 = LocalPlayer;
    local v70;

    if v69 then
        v70 = v69.Character;
    else
        v70 = v69;
    end;

    local v71;

    if v70 then
        v71 = u25[v69];

        if not v71 or v71.Parent ~= v70 then
            u25[v69] = nil;
            v71 = v70:FindFirstChildOfClass("Humanoid");

            if v71 then
                u25[v69] = v71;
            end;
        end;
    else
        v71 = nil;
    end;

    u67.Humanoid = v71;
    u67.OriginPoint = nil;
    u67.AgentCanFollowPath = false;
    u67.DirectPath = false;
    u67.DirectPathRiseFirst = false;
    u67.stopTraverseFunc = nil;
    u67.setPointFunc = nil;
    u67.pointList = nil;
    local v72 = u67.Humanoid and u67.Humanoid.RootPart;

    if v72 then
        u67.OriginPoint = v72.CFrame.Position;
        local v73 = 2;
        local v74 = 5;
        local v75 = true;
        local SeatPart = u67.Humanoid.SeatPart;

        if SeatPart and SeatPart:IsA("VehicleSeat") then
            local v76 = SeatPart:FindFirstAncestorOfClass("Model");

            if v76 then
                local PrimaryPart = v76.PrimaryPart;
                v76.PrimaryPart = SeatPart;

                if p66 then
                    local v77 = v76:GetExtentsSize();
                    v73 = u8 * 0.5 * math.sqrt(v77.X * v77.X + v77.Z * v77.Z);
                    v74 = u8 * v77.Y;
                    u67.AgentCanFollowPath = true;
                    u67.DirectPath = p66;
                    v75 = false;
                end;

                v76.PrimaryPart = PrimaryPart;
            end;
        else
            local v78 = nil;

            if u1 then
                local v79 = LocalPlayer and LocalPlayer.Character;

                if v79 ~= nil then
                    v78 = getCollidableExtentsSize(v79);
                end;
            end;

            if v78 == nil then
                v78 = (LocalPlayer and LocalPlayer.Character):GetExtentsSize();
            end;

            assert(v78, "");
            v73 = u8 * 0.5 * math.sqrt(v78.X * v78.X + v78.Z * v78.Z);
            v74 = u8 * v78.Y;
            v75 = u67.Humanoid.JumpPower > 0;
            u67.AgentCanFollowPath = true;
            u67.DirectPath = v68;
            u67.DirectPathRiseFirst = u67.Humanoid.Sit;
        end;

        if u2 then
            u67.pathResult = PathfindingService:CreatePath({
                AgentCanClimb = true,
                AgentRadius = v73,
                AgentHeight = v74,
                AgentCanJump = v75
            });
        else
            u67.pathResult = PathfindingService:CreatePath({
                AgentRadius = v73,
                AgentHeight = v74,
                AgentCanJump = v75
            });
        end;
    end;

    function u67.Cleanup(p80) -- Line: 333
        -- upvalues: u67 (copy)
        if u67.stopTraverseFunc then
            u67.stopTraverseFunc();
            u67.stopTraverseFunc = nil;
        end;

        if u67.BlockedConn then
            u67.BlockedConn:Disconnect();
            u67.BlockedConn = nil;
        end;

        if u67.DiedConn then
            u67.DiedConn:Disconnect();
            u67.DiedConn = nil;
        end;

        if u67.SeatedConn then
            u67.SeatedConn:Disconnect();
            u67.SeatedConn = nil;
        end;

        if u67.TeleportedConn then
            u67.TeleportedConn:Disconnect();
            u67.TeleportedConn = nil;
        end;

        u67.Started = false;
    end;

    function u67.Cancel(p81) -- Line: 362
        -- upvalues: u67 (copy)
        u67.Cancelled = true;
        u67:Cleanup();
    end;

    function u67.IsActive(p82) -- Line: 367
        -- upvalues: u67 (copy)
        return u67.AgentCanFollowPath and u67.Started and not u67.Cancelled;
    end;

    function u67.OnPathInterrupted(p83) -- Line: 371
        -- upvalues: u67 (copy)
        u67.Cancelled = true;
        u67:OnPointReached(false);
    end;

    function u67.ComputePath(p84) -- Line: 377
        -- upvalues: u67 (copy)
        if u67.OriginPoint then
            if u67.PathComputed or u67.PathComputing then
                return;
            end;

            u67.PathComputing = true;

            if u67.AgentCanFollowPath then
                if u67.DirectPath then
                    u67.pointList = { PathWaypoint.new(u67.OriginPoint, Enum.PathWaypointAction.Walk), PathWaypoint.new(u67.TargetPoint, u67.DirectPathRiseFirst and Enum.PathWaypointAction.Jump or Enum.PathWaypointAction.Walk) };
                    u67.PathComputed = true;
                else
                    u67.pathResult:ComputeAsync(u67.OriginPoint, u67.TargetPoint);
                    u67.pointList = u67.pathResult:GetWaypoints();
                    u67.BlockedConn = u67.pathResult.Blocked:Connect(function(p85) -- Line: 391
                        -- upvalues: u67 (ref)
                        u67:OnPathBlocked(p85);
                    end);
                    u67.PathComputed = u67.pathResult.Status == Enum.PathStatus.Success;
                end;
            end;

            u67.PathComputing = false;
        end;
    end;

    function u67.IsValidPath(p86) -- Line: 399
        -- upvalues: u67 (copy)
        u67:ComputePath();

        return u67.PathComputed and u67.AgentCanFollowPath;
    end;

    u67.Recomputing = false;

    function u67.OnPathBlocked(p87, p88) -- Line: 405
        -- upvalues: u67 (copy), u5 (ref), ClickToMoveDisplay (ref)
        if u67.CurrentPoint > p88 or u67.Recomputing then
            return;
        end;

        u67.Recomputing = true;

        if u67.stopTraverseFunc then
            u67.stopTraverseFunc();
            u67.stopTraverseFunc = nil;
        end;

        u67.OriginPoint = u67.Humanoid.RootPart.CFrame.p;
        u67.pathResult:ComputeAsync(u67.OriginPoint, u67.TargetPoint);
        u67.pointList = u67.pathResult:GetWaypoints();

        if #u67.pointList > 0 then
            u67.HumanoidOffsetFromPath = u67.pointList[1].Position - u67.OriginPoint;
        end;

        u67.PathComputed = u67.pathResult.Status == Enum.PathStatus.Success;

        if u5 then
            local v89, v90 = ClickToMoveDisplay.CreatePathDisplay(u67.pointList);
            u67.stopTraverseFunc = v89;
            u67.setPointFunc = v90;
        end;

        if u67.PathComputed then
            u67.CurrentPoint = 1;
            u67:OnPointReached(true);
        else
            u67.PathFailed:Fire();
            u67:Cleanup();
        end;

        u67.Recomputing = false;
    end;

    function u67.OnRenderStepped(p91, p92) -- Line: 441
        -- upvalues: u67 (copy), u9 (ref)
        if u67.Started and not u67.Cancelled then
            u67.Timeout = u67.Timeout + p92;

            if u9 < u67.Timeout then
                u67:OnPointReached(false);

                return;
            end;

            u67.CurrentHumanoidPosition = u67.Humanoid.RootPart.Position + u67.HumanoidOffsetFromPath;
            u67.CurrentHumanoidVelocity = u67.Humanoid.RootPart.Velocity;

            while u67.Started and u67:IsCurrentWaypointReached() do
                u67:OnPointReached(true);
            end;

            if u67.Started then
                u67.NextActionMoveDirection = u67.CurrentWaypointPosition - u67.CurrentHumanoidPosition;

                if u67.NextActionMoveDirection.Magnitude > 1e-6 then
                    u67.NextActionMoveDirection = u67.NextActionMoveDirection.Unit;
                else
                    u67.NextActionMoveDirection = Vector3.new(0, 0, 0);
                end;

                if u67.CurrentWaypointNeedsJump then
                    u67.NextActionJump = true;
                    u67.CurrentWaypointNeedsJump = false;

                    return;
                end;

                u67.NextActionJump = false;
            end;
        end;
    end;

    function u67.IsCurrentWaypointReached(p93) -- Line: 479
        -- upvalues: u67 (copy)
        local v94;

        if u67.CurrentWaypointPlaneNormal == Vector3.new(0, 0, 0) then
            v94 = true;
        else
            local v95 = u67.CurrentWaypointPlaneNormal:Dot(u67.CurrentHumanoidPosition) - u67.CurrentWaypointPlaneDistance;
            local v96 = 0.0625 * -u67.CurrentWaypointPlaneNormal:Dot(u67.CurrentHumanoidVelocity);
            v94 = v95 < math.max(1, v96);
        end;

        if v94 then
            u67.CurrentWaypointPosition = nil;
            u67.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0);
            u67.CurrentWaypointPlaneDistance = 0;
        end;

        return v94;
    end;

    function u67.OnPointReached(p97, p98) -- Line: 505
        -- upvalues: u67 (copy)
        if not p98 or u67.Cancelled then
            u67.PathFailed:Fire();
            u67:Cleanup();

            return;
        end;

        if u67.setPointFunc then
            u67.setPointFunc(u67.CurrentPoint);
        end;

        local v99 = u67.CurrentPoint + 1;

        if #u67.pointList < v99 then
            if u67.stopTraverseFunc then
                u67.stopTraverseFunc();
            end;

            u67.Finished:Fire();
            u67:Cleanup();

            return;
        end;

        local v100 = u67.pointList[u67.CurrentPoint];
        local v101 = u67.pointList[v99];
        local v102 = u67.Humanoid:GetState();

        if (v102 == Enum.HumanoidStateType.FallingDown or v102 == Enum.HumanoidStateType.Freefall) and true or v102 == Enum.HumanoidStateType.Jumping then
            local v103 = v101.Action == Enum.PathWaypointAction.Jump;

            if not v103 and u67.CurrentPoint > 1 then
                local v104 = v100.Position - u67.pointList[u67.CurrentPoint - 1].Position;
                local v105 = v101.Position - v100.Position;
                v103 = Vector2.new(v104.x, v104.z).Unit:Dot(Vector2.new(v105.x, v105.z).Unit) < 0.996;
            end;

            if v103 then
                u67.Humanoid.FreeFalling:Wait();
                wait(0.1);
            end;
        end;

        u67:MoveToNextWayPoint(v100, v101, v99);
    end;

    function u67.MoveToNextWayPoint(p106, p107, p108, p109) -- Line: 568
        -- upvalues: u67 (copy), u2 (ref)
        u67.CurrentWaypointPlaneNormal = p107.Position - p108.Position;

        if not u2 or p108.Label ~= "Climb" then
            u67.CurrentWaypointPlaneNormal = Vector3.new(u67.CurrentWaypointPlaneNormal.X, 0, u67.CurrentWaypointPlaneNormal.Z);
        end;

        if u67.CurrentWaypointPlaneNormal.Magnitude > 1e-6 then
            u67.CurrentWaypointPlaneNormal = u67.CurrentWaypointPlaneNormal.Unit;
            u67.CurrentWaypointPlaneDistance = u67.CurrentWaypointPlaneNormal:Dot(p108.Position);
        else
            u67.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0);
            u67.CurrentWaypointPlaneDistance = 0;
        end;

        u67.CurrentWaypointNeedsJump = p108.Action == Enum.PathWaypointAction.Jump;
        u67.CurrentWaypointPosition = p108.Position;
        u67.CurrentPoint = p109;
        u67.Timeout = 0;
    end;

    function u67.Start(p110, p111) -- Line: 600
        -- upvalues: u67 (copy), ClickToMoveDisplay (ref), u5 (ref)
        if not u67.AgentCanFollowPath then
            u67.PathFailed:Fire();

            return;
        end;

        if u67.Started then
            return;
        end;

        u67.Started = true;
        ClickToMoveDisplay.CancelFailureAnimation();

        if u5 and (p111 == nil or p111) then
            local v112, v113 = ClickToMoveDisplay.CreatePathDisplay(u67.pointList, u67.OriginalTargetPoint);
            u67.stopTraverseFunc = v112;
            u67.setPointFunc = v113;
        end;

        if #u67.pointList <= 0 then
            u67.PathFailed:Fire();

            if u67.stopTraverseFunc then
                u67.stopTraverseFunc();
            end;

            return;
        end;

        u67.HumanoidOffsetFromPath = Vector3.new(0, u67.pointList[1].Position.Y - u67.OriginPoint.Y, 0);
        u67.CurrentHumanoidPosition = u67.Humanoid.RootPart.Position + u67.HumanoidOffsetFromPath;
        u67.CurrentHumanoidVelocity = u67.Humanoid.RootPart.Velocity;
        u67.SeatedConn = u67.Humanoid.Seated:Connect(function(p114, p115) -- Line: 627
            -- upvalues: u67 (ref)
            u67:OnPathInterrupted();
        end);
        u67.DiedConn = u67.Humanoid.Died:Connect(function() -- Line: 628
            -- upvalues: u67 (ref)
            u67:OnPathInterrupted();
        end);
        u67.TeleportedConn = u67.Humanoid.RootPart:GetPropertyChangedSignal("CFrame"):Connect(function() -- Line: 629
            -- upvalues: u67 (ref)
            u67:OnPathInterrupted();
        end);
        u67.CurrentPoint = 1;
        u67:OnPointReached(true);
    end;

    local v116 = u67.TargetPoint + u67.TargetSurfaceNormal * 1.5;

    if u3 then
        local v117;

        if u30 then
            v117 = u30;
        else
            u30 = {};
            assert(u30, "");
            table.insert(u30, LocalPlayer and LocalPlayer.Character);
            v117 = u30;
        end;

        u11.FilterDescendantsInstances = v117;
        local v118 = Workspace:Raycast(v116, Vector3.new(-0, -50, -0), u11);

        if v118 then
            u67.TargetPoint = v118.Position;
        end;
    else
        local v119 = Ray.new(v116, Vector3.new(0, -50, 0));
        local v120;

        if u30 then
            v120 = u30;
        else
            u30 = {};
            assert(u30, "");
            table.insert(u30, LocalPlayer and LocalPlayer.Character);
            v120 = u30;
        end;

        local v121, v122 = Workspace:FindPartOnRayWithIgnoreList(v119, v120);

        if v121 then
            u67.TargetPoint = v122;
        end;
    end;

    u67:ComputePath();

    return u67;
end;

local function CheckAlive() -- Line: 665
    -- upvalues: LocalPlayer (copy), u25 (copy)
    local v123 = LocalPlayer;
    local v124;

    if v123 then
        v124 = v123.Character;
    else
        v124 = v123;
    end;

    local v125;

    if v124 then
        v125 = u25[v123];

        if not v125 or v125.Parent ~= v124 then
            u25[v123] = nil;
            v125 = v124:FindFirstChildOfClass("Humanoid");

            if v125 then
                u25[v123] = v125;
            end;
        end;
    else
        v125 = nil;
    end;

    local v126;

    if v125 == nil then
        v126 = false;
    else
        v126 = v125.Health > 0;
    end;

    return v126;
end;

local function GetEquippedTool(p127) -- Line: 670
    if p127 ~= nil then
        for _, child in pairs(p127:GetChildren()) do
            if child:IsA("Tool") then
                return child;
            end;
        end;
    end;
end;

local u128 = nil;
local u129 = nil;
local u130 = nil;

local function CleanupPath() -- Line: 685
    -- upvalues: u128 (ref), u129 (ref), u130 (ref)
    if u128 then
        u128:Cancel();
        u128 = nil;
    end;

    if u129 then
        u129:Disconnect();
        u129 = nil;
    end;

    if u130 then
        u130:Disconnect();
        u130 = nil;
    end;
end;

local function HandleMoveTo(p131, u132, u133, u134, u135) -- Line: 703
    -- upvalues: u128 (ref), u129 (ref), u130 (ref), GetEquippedTool (copy), u6 (ref), ClickToMoveDisplay (copy)
    if u128 then
        if u128 then
            u128:Cancel();
            u128 = nil;
        end;

        if u129 then
            u129:Disconnect();
            u129 = nil;
        end;

        if u130 then
            u130:Disconnect();
            u130 = nil;
        end;
    end;

    u128 = p131;
    p131:Start(u135);
    u129 = p131.Finished.Event:Connect(function() -- Line: 710
        -- upvalues: u128 (ref), u129 (ref), u130 (ref), u133 (copy), GetEquippedTool (ref), u134 (copy)
        if u128 then
            u128:Cancel();
            u128 = nil;
        end;

        if u129 then
            u129:Disconnect();
            u129 = nil;
        end;

        if u130 then
            u130:Disconnect();
            u130 = nil;
        end;

        local v136 = u133 and GetEquippedTool(u134);

        if v136 then
            v136:Activate();
        end;
    end);
    u130 = p131.PathFailed.Event:Connect(function() -- Line: 719
        -- upvalues: u128 (ref), u129 (ref), u130 (ref), u135 (copy), u6 (ref), ClickToMoveDisplay (ref), u132 (copy)
        if u128 then
            u128:Cancel();
            u128 = nil;
        end;

        if u129 then
            u129:Disconnect();
            u129 = nil;
        end;

        if u130 then
            u130:Disconnect();
            u130 = nil;
        end;

        if u135 == nil or u135 then
            local v137 = u6;

            if v137 then
                local v138 = u128 and u128:IsActive();
                v137 = not v138;
            end;

            if v137 then
                ClickToMoveDisplay.PlayFailureAnimation();
            end;

            ClickToMoveDisplay.DisplayFailureWaypoint(u132);
        end;
    end);
end;

local function ShowPathFailedFeedback(p139) -- Line: 731
    -- upvalues: u128 (ref), u6 (ref), ClickToMoveDisplay (copy)
    if u128 and u128:IsActive() then
        u128:Cancel();
    end;

    if u6 then
        ClickToMoveDisplay.PlayFailureAnimation();
    end;

    ClickToMoveDisplay.DisplayFailureWaypoint(p139);
end;

function OnTap(p140, p141, p142)
    -- upvalues: Workspace (copy), LocalPlayer (copy), u25 (copy), u3 (copy), u30 (ref), u11 (copy), StarterGui (copy), Players (copy), u128 (ref), u129 (ref), u130 (ref), Pather (copy), HandleMoveTo (copy), u6 (ref), ClickToMoveDisplay (copy), u12 (copy), GetEquippedTool (copy)
    local CurrentCamera = Workspace.CurrentCamera;
    local Character = LocalPlayer.Character;
    local v143 = LocalPlayer;
    local v144;

    if v143 then
        v144 = v143.Character;
    else
        v144 = v143;
    end;

    local v145;

    if v144 then
        v145 = u25[v143];

        if not v145 or v145.Parent ~= v144 then
            u25[v143] = nil;
            v145 = v144:FindFirstChildOfClass("Humanoid");

            if v145 then
                u25[v143] = v145;
            end;
        end;
    else
        v145 = nil;
    end;

    local v146;

    if v145 == nil then
        v146 = false;
    else
        v146 = v145.Health > 0;
    end;

    if not v146 then
        return;
    end;

    if #p140 ~= 1 and not p141 then
        local v147 = #p140 >= 2 and (CurrentCamera and GetEquippedTool(Character));

        if v147 then
            v147:Activate();
        end;

        return;
    end;

    if not CurrentCamera then
        return;
    end;

    local v148 = CurrentCamera:ScreenPointToRay(p140[1].X, p140[1].Y);

    if not u3 then
        local v149 = Ray.new(v148.Origin, v148.Direction * 1000);
        local Raycast = u12.Raycast;
        local v150;

        if u30 then
            v150 = u30;
        else
            u30 = {};
            assert(u30, "");
            table.insert(u30, LocalPlayer and LocalPlayer.Character);
            v150 = u30;
        end;

        local v151, v152, v153 = Raycast(v149, true, v150);
        local v154, v155 = u12.FindCharacterAncestor(v151);

        if p142 and (v155 and (StarterGui:GetCore("AvatarContextMenuEnabled") and Players:GetPlayerFromCharacter(v155.Parent))) then
            if u128 then
                u128:Cancel();
                u128 = nil;
            end;

            if u129 then
                u129:Disconnect();
                u129 = nil;
            end;

            if u130 then
                u130:Disconnect();
                u130 = nil;
            end;

            return;
        end;

        if p141 then
            v154 = nil;
        else
            p141 = v152;
        end;

        if p141 and Character then
            if u128 then
                u128:Cancel();
                u128 = nil;
            end;

            if u129 then
                u129:Disconnect();
                u129 = nil;
            end;

            if u130 then
                u130:Disconnect();
                u130 = nil;
            end;

            local v156 = Pather(p141, v153);

            if v156:IsValidPath() then
                HandleMoveTo(v156, p141, v154, Character);

                return;
            end;

            v156:Cleanup();

            if u128 and u128:IsActive() then
                u128:Cancel();
            end;

            if u6 then
                ClickToMoveDisplay.PlayFailureAnimation();
            end;

            ClickToMoveDisplay.DisplayFailureWaypoint(p141);

            return;
        end;

        return;
    end;

    local v157 = nil;
    local v158 = nil;
    local v159;

    if u30 then
        v159 = u30;
    else
        u30 = {};
        assert(u30, "");
        table.insert(u30, LocalPlayer and LocalPlayer.Character);
        v159 = u30;
    end;

    if not v159 then
        v159 = {};
    end;

    while true do
        local v160 = true;
        u11.FilterDescendantsInstances = v159;
        local v161 = Workspace:Raycast(v148.Origin, v148.Direction * 1000, u11);
        local v162, v163;

        if v161 then
            local Instance2 = v161.Instance;

            if not Instance2.CanCollide then
                local v164;

                while true do
                    v157 = Instance2:FindFirstChildOfClass("Humanoid");
                    v164 = Instance2.Parent;

                    if v157 or (not v164 or v164 == Workspace) then
                        break;
                    end;

                    Instance2 = v164;
                end;

                if v157 then
                    v158 = Instance2;
                else
                    table.insert(v159, v164);
                    v160 = false;
                    v158 = nil;
                end;

                if v160 then
                    if p142 and (v157 and (StarterGui:GetCore("AvatarContextMenuEnabled") and Players:GetPlayerFromCharacter(v157.Parent))) then
                        if u128 then
                            u128:Cancel();
                            u128 = nil;
                        end;

                        if u129 then
                            u129:Disconnect();
                            u129 = nil;
                        end;

                        if u130 then
                            u130:Disconnect();
                            u130 = nil;
                        end;

                        return;
                    end;

                    if not (v161 and Character) then
                        return;
                    end;

                    v162 = v161.Position;

                    if p141 then
                        v158 = nil;
                    else
                        p141 = v162;
                    end;

                    if u128 then
                        u128:Cancel();
                        u128 = nil;
                    end;

                    if u129 then
                        u129:Disconnect();
                        u129 = nil;
                    end;

                    if u130 then
                        u130:Disconnect();
                        u130 = nil;
                    end;

                    v163 = Pather(p141, v161.Normal);

                    if v163:IsValidPath() then
                        HandleMoveTo(v163, p141, v158, Character);

                        return;
                    end;

                    v163:Cleanup();

                    if u128 and u128:IsActive() then
                        u128:Cancel();
                    end;

                    if u6 then
                        ClickToMoveDisplay.PlayFailureAnimation();
                    end;

                    ClickToMoveDisplay.DisplayFailureWaypoint(p141);

                    return;
                end;
            end;
        end;

        if v160 then
            if p142 and (v157 and (StarterGui:GetCore("AvatarContextMenuEnabled") and Players:GetPlayerFromCharacter(v157.Parent))) then
                if u128 then
                    u128:Cancel();
                    u128 = nil;
                end;

                if u129 then
                    u129:Disconnect();
                    u129 = nil;
                end;

                if u130 then
                    u130:Disconnect();
                    u130 = nil;
                end;

                return;
            end;

            if not (v161 and Character) then
                return;
            end;

            v162 = v161.Position;

            if p141 then
                v158 = nil;
            else
                p141 = v162;
            end;

            if u128 then
                u128:Cancel();
                u128 = nil;
            end;

            if u129 then
                u129:Disconnect();
                u129 = nil;
            end;

            if u130 then
                u130:Disconnect();
                u130 = nil;
            end;

            v163 = Pather(p141, v161.Normal);

            if v163:IsValidPath() then
                HandleMoveTo(v163, p141, v158, Character);

                return;
            end;

            v163:Cleanup();

            if u128 and u128:IsActive() then
                u128:Cancel();
            end;

            if u6 then
                ClickToMoveDisplay.PlayFailureAnimation();
            end;

            ClickToMoveDisplay.DisplayFailureWaypoint(p141);

            return;
        end;
    end;
end;

local function DisconnectEvent(p165) -- Line: 851
    if p165 then
        p165:Disconnect();
    end;
end;

local Keyboard = require(script.Parent:WaitForChild("Keyboard"));
local u166 = setmetatable({}, Keyboard);
u166.__index = u166;

function u166.new(p167) -- Line: 862
    -- upvalues: Keyboard (copy), u166 (copy)
    local v168 = Keyboard.new(p167);
    local v169 = setmetatable(v168, u166);
    v169.fingerTouches = {};
    v169.numUnsunkTouches = 0;
    v169.mouse2DownTime = tick();
    v169.mouse2DownPos = Vector2.new();
    v169.mouse2UpTime = tick();
    v169.keyboardMoveVector = Vector3.new(0, 0, 0);
    v169.tapConn = nil;
    v169.inputBeganConn = nil;
    v169.inputChangedConn = nil;
    v169.inputEndedConn = nil;
    v169.humanoidDiedConn = nil;
    v169.characterChildAddedConn = nil;
    v169.onCharacterAddedConn = nil;
    v169.characterChildRemovedConn = nil;
    v169.renderSteppedConn = nil;
    v169.menuOpenedConnection = nil;
    v169.preferredInputChangedConnection = nil;
    v169.running = false;
    v169.wasdEnabled = false;

    return v169;
end;

function u166.DisconnectEvents(p170) -- Line: 893
    -- upvalues: u4 (copy)
    local tapConn = p170.tapConn;

    if tapConn then
        tapConn:Disconnect();
    end;

    local inputBeganConn = p170.inputBeganConn;

    if inputBeganConn then
        inputBeganConn:Disconnect();
    end;

    local inputChangedConn = p170.inputChangedConn;

    if inputChangedConn then
        inputChangedConn:Disconnect();
    end;

    local inputEndedConn = p170.inputEndedConn;

    if inputEndedConn then
        inputEndedConn:Disconnect();
    end;

    local humanoidDiedConn = p170.humanoidDiedConn;

    if humanoidDiedConn then
        humanoidDiedConn:Disconnect();
    end;

    local characterChildAddedConn = p170.characterChildAddedConn;

    if characterChildAddedConn then
        characterChildAddedConn:Disconnect();
    end;

    local onCharacterAddedConn = p170.onCharacterAddedConn;

    if onCharacterAddedConn then
        onCharacterAddedConn:Disconnect();
    end;

    local renderSteppedConn = p170.renderSteppedConn;

    if renderSteppedConn then
        renderSteppedConn:Disconnect();
    end;

    local characterChildRemovedConn = p170.characterChildRemovedConn;

    if characterChildRemovedConn then
        characterChildRemovedConn:Disconnect();
    end;

    local menuOpenedConnection = p170.menuOpenedConnection;

    if menuOpenedConnection then
        menuOpenedConnection:Disconnect();
    end;

    local v171 = u4 and p170.preferredInputChangedConnection;

    if v171 then
        v171:Disconnect();
    end;
end;

function u166.OnTouchBegan(p172, p173, p174) -- Line: 909
    if p172.fingerTouches[p173] == nil and not p174 then
        p172.numUnsunkTouches = p172.numUnsunkTouches + 1;
    end;

    p172.fingerTouches[p173] = p174;
end;

function u166.OnTouchChanged(p175, p176, p177) -- Line: 916
    if p175.fingerTouches[p176] == nil then
        p175.fingerTouches[p176] = p177;

        if not p177 then
            p175.numUnsunkTouches = p175.numUnsunkTouches + 1;
        end;
    end;
end;

function u166.OnTouchEnded(p178, p179, p180) -- Line: 925
    if p178.fingerTouches[p179] ~= nil and p178.fingerTouches[p179] == false then
        p178.numUnsunkTouches = p178.numUnsunkTouches - 1;
    end;

    p178.fingerTouches[p179] = nil;
end;

function u166.OnPreferredInputChanged(p181) -- Line: 932
    -- upvalues: LocalPlayer (copy), UserInputService (copy)
    local Character = LocalPlayer.Character;

    if Character then
        local v182 = UserInputService.PreferredInput == Enum.PreferredInput.Touch;

        for _, child in pairs(Character:GetChildren()) do
            if child:IsA("Tool") then
                child.ManualActivationOnly = v182;
            end;
        end;
    end;
end;

function u166.OnCharacterAdded(u183, p184) -- Line: 944
    -- upvalues: UserInputService (copy), u10 (copy), u128 (ref), u129 (ref), u130 (ref), ClickToMoveDisplay (copy), GuiService (copy), u4 (copy)
    u183:DisconnectEvents();
    u183.inputBeganConn = UserInputService.InputBegan:Connect(function(p185, p186) -- Line: 947
        -- upvalues: u183 (copy), u10 (ref), u128 (ref), u129 (ref), u130 (ref), ClickToMoveDisplay (ref)
        if p185.UserInputType == Enum.UserInputType.Touch then
            u183:OnTouchBegan(p185, p186);
        end;

        if u183.wasdEnabled and (p186 == false and (p185.UserInputType == Enum.UserInputType.Keyboard and u10[p185.KeyCode])) then
            if u128 then
                u128:Cancel();
                u128 = nil;
            end;

            if u129 then
                u129:Disconnect();
                u129 = nil;
            end;

            if u130 then
                u130:Disconnect();
                u130 = nil;
            end;

            ClickToMoveDisplay.CancelFailureAnimation();
        end;

        if p185.UserInputType == Enum.UserInputType.MouseButton2 then
            u183.mouse2DownTime = tick();
            u183.mouse2DownPos = p185.Position;
        end;
    end);
    u183.inputChangedConn = UserInputService.InputChanged:Connect(function(p187, p188) -- Line: 964
        -- upvalues: u183 (copy)
        if p187.UserInputType == Enum.UserInputType.Touch then
            u183:OnTouchChanged(p187, p188);
        end;
    end);
    u183.inputEndedConn = UserInputService.InputEnded:Connect(function(p189, p190) -- Line: 970
        -- upvalues: u183 (copy), u128 (ref)
        if p189.UserInputType == Enum.UserInputType.Touch then
            u183:OnTouchEnded(p189, p190);
        end;

        if p189.UserInputType == Enum.UserInputType.MouseButton2 then
            u183.mouse2UpTime = tick();
            local Position = p189.Position;

            if u183.mouse2UpTime - u183.mouse2DownTime < 0.25 and ((Position - u183.mouse2DownPos).magnitude < 5 and (u128 or u183.keyboardMoveVector.Magnitude <= 0)) then
                OnTap({ Position });
            end;
        end;
    end);
    u183.tapConn = UserInputService.TouchTap:Connect(function(p191, p192) -- Line: 987
        if not p192 then
            OnTap(p191, nil, true);
        end;
    end);
    u183.menuOpenedConnection = GuiService.MenuOpened:Connect(function() -- Line: 993
        -- upvalues: u128 (ref), u129 (ref), u130 (ref)
        if u128 then
            u128:Cancel();
            u128 = nil;
        end;

        if u129 then
            u129:Disconnect();
            u129 = nil;
        end;

        if u130 then
            u130:Disconnect();
            u130 = nil;
        end;
    end);

    local function OnCharacterChildAdded(p193) -- Line: 997
        -- upvalues: u4 (ref), UserInputService (ref), u183 (copy)
        local v194;

        if u4 then
            v194 = UserInputService.PreferredInput == Enum.PreferredInput.Touch;
        else
            v194 = UserInputService.TouchEnabled;
        end;

        if v194 and p193:IsA("Tool") then
            p193.ManualActivationOnly = true;
        end;

        if p193:IsA("Humanoid") then
            local humanoidDiedConn = u183.humanoidDiedConn;

            if humanoidDiedConn then
                humanoidDiedConn:Disconnect();
            end;

            u183.humanoidDiedConn = p193.Died:Connect(function() -- Line: 1011
            end);
        end;
    end;

    u183.characterChildAddedConn = p184.ChildAdded:Connect(function(p195) -- Line: 1019
        -- upvalues: OnCharacterChildAdded (copy)
        OnCharacterChildAdded(p195);
    end);
    u183.characterChildRemovedConn = p184.ChildRemoved:Connect(function(p196) -- Line: 1022
        -- upvalues: u4 (ref), UserInputService (ref)
        local v197;

        if u4 then
            v197 = UserInputService.PreferredInput == Enum.PreferredInput.Touch;
        else
            v197 = UserInputService.TouchEnabled;
        end;

        if v197 and p196:IsA("Tool") then
            p196.ManualActivationOnly = false;
        end;
    end);

    for _, child in pairs(p184:GetChildren()) do
        OnCharacterChildAdded(child);
    end;

    if u4 then
        u183.preferredInputChangedConnection = UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- Line: 1040
            -- upvalues: u183 (copy)
            u183:OnPreferredInputChanged();
        end);
    end;
end;

function u166.Start(p198) -- Line: 1046
    p198:Enable(true);
end;

function u166.Stop(p199) -- Line: 1050
    p199:Enable(false);
end;

function u166.CleanupPath(p200) -- Line: 1054
    -- upvalues: u128 (ref), u129 (ref), u130 (ref)
    if u128 then
        u128:Cancel();
        u128 = nil;
    end;

    if u129 then
        u129:Disconnect();
        u129 = nil;
    end;

    if u130 then
        u130:Disconnect();
        u130 = nil;
    end;
end;

function u166.Enable(u201, p202, p203, p204) -- Line: 1058
    -- upvalues: LocalPlayer (copy), u128 (ref), u129 (ref), u130 (ref), u4 (copy), UserInputService (copy), Keyboard (copy)
    if p202 then
        if not u201.running then
            if LocalPlayer.Character then
                u201:OnCharacterAdded(LocalPlayer.Character);
            end;

            u201.onCharacterAddedConn = LocalPlayer.CharacterAdded:Connect(function(p205) -- Line: 1064
                -- upvalues: u201 (copy)
                u201:OnCharacterAdded(p205);
            end);
            u201.running = true;
        end;

        u201.touchJumpController = p204;

        if u201.touchJumpController then
            u201.touchJumpController:Enable(u201.jumpEnabled);
        end;
    else
        if u201.running then
            u201:DisconnectEvents();

            if u128 then
                u128:Cancel();
                u128 = nil;
            end;

            if u129 then
                u129:Disconnect();
                u129 = nil;
            end;

            if u130 then
                u130:Disconnect();
                u130 = nil;
            end;

            local v206;

            if u4 then
                v206 = UserInputService.PreferredInput == Enum.PreferredInput.Touch;
            else
                v206 = UserInputService.TouchEnabled;
            end;

            if v206 then
                local Character = LocalPlayer.Character;

                if Character then
                    for _, child in pairs(Character:GetChildren()) do
                        if child:IsA("Tool") then
                            child.ManualActivationOnly = false;
                        end;
                    end;
                end;
            end;

            u201.running = false;
        end;

        if u201.touchJumpController and not u201.jumpEnabled then
            u201.touchJumpController:Enable(true);
        end;

        u201.touchJumpController = nil;
    end;

    Keyboard.Enable(u201, p202);
    u201.wasdEnabled = p202 and p203 and p203 or false;
    u201.enabled = p202;
end;

function u166.OnRenderStepped(p207, p208) -- Line: 1109
    -- upvalues: u128 (ref)
    p207.isJumping = false;

    if u128 then
        u128:OnRenderStepped(p208);

        if u128 then
            p207.moveVector = u128.NextActionMoveDirection;
            p207.moveVectorIsCameraRelative = false;

            if u128.NextActionJump then
                p207.isJumping = true;
            end;
        else
            p207.moveVector = p207.keyboardMoveVector;
            p207.moveVectorIsCameraRelative = true;
        end;
    else
        p207.moveVector = p207.keyboardMoveVector;
        p207.moveVectorIsCameraRelative = true;
    end;

    if p207.jumpRequested then
        p207.isJumping = true;
    end;
end;

function u166.UpdateMovement(p209, p210) -- Line: 1144
    if p210 == Enum.UserInputState.Cancel then
        p209.keyboardMoveVector = Vector3.new(0, 0, 0);

        return;
    end;

    if p209.wasdEnabled then
        p209.keyboardMoveVector = Vector3.new(p209.leftValue + p209.rightValue, 0, p209.forwardValue + p209.backwardValue);
    end;
end;

function u166.UpdateJump(p211) -- Line: 1153
end;

function u166.SetShowPath(p212, p213) -- Line: 1158
    -- upvalues: u5 (ref)
    u5 = p213;
end;

function u166.GetShowPath(p214) -- Line: 1162
    -- upvalues: u5 (ref)
    return u5;
end;

function u166.SetWaypointTexture(p215, p216) -- Line: 1166
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetWaypointTexture(p216);
end;

function u166.GetWaypointTexture(p217) -- Line: 1170
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetWaypointTexture();
end;

function u166.SetWaypointRadius(p218, p219) -- Line: 1174
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetWaypointRadius(p219);
end;

function u166.GetWaypointRadius(p220) -- Line: 1178
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetWaypointRadius();
end;

function u166.SetEndWaypointTexture(p221, p222) -- Line: 1182
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetEndWaypointTexture(p222);
end;

function u166.GetEndWaypointTexture(p223) -- Line: 1186
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetEndWaypointTexture();
end;

function u166.SetWaypointsAlwaysOnTop(p224, p225) -- Line: 1190
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetWaypointsAlwaysOnTop(p225);
end;

function u166.GetWaypointsAlwaysOnTop(p226) -- Line: 1194
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetWaypointsAlwaysOnTop();
end;

function u166.SetFailureAnimationEnabled(p227, p228) -- Line: 1198
    -- upvalues: u6 (ref)
    u6 = p228;
end;

function u166.GetFailureAnimationEnabled(p229) -- Line: 1202
    -- upvalues: u6 (ref)
    return u6;
end;

function u166.SetIgnoredPartsTag(p230, p231) -- Line: 1206
    -- upvalues: UpdateIgnoreTag (copy)
    UpdateIgnoreTag(p231);
end;

function u166.GetIgnoredPartsTag(p232) -- Line: 1210
    -- upvalues: u31 (ref)
    return u31;
end;

function u166.SetUseDirectPath(p233, p234) -- Line: 1214
    -- upvalues: u7 (ref)
    u7 = p234;
end;

function u166.GetUseDirectPath(p235) -- Line: 1218
    -- upvalues: u7 (ref)
    return u7;
end;

function u166.SetAgentSizeIncreaseFactor(p236, p237) -- Line: 1222
    -- upvalues: u8 (ref)
    u8 = p237 / 100 + 1;
end;

function u166.GetAgentSizeIncreaseFactor(p238) -- Line: 1226
    -- upvalues: u8 (ref)
    return (u8 - 1) * 100;
end;

function u166.SetUnreachableWaypointTimeout(p239, p240) -- Line: 1230
    -- upvalues: u9 (ref)
    u9 = p240;
end;

function u166.GetUnreachableWaypointTimeout(p241) -- Line: 1234
    -- upvalues: u9 (ref)
    return u9;
end;

function u166.SetUserJumpEnabled(p242, p243) -- Line: 1238
    p242.jumpEnabled = p243;

    if p242.touchJumpController then
        p242.touchJumpController:Enable(p243);
    end;
end;

function u166.GetUserJumpEnabled(p244) -- Line: 1245
    return p244.jumpEnabled;
end;

function u166.MoveTo(p245, p246, p247, p248) -- Line: 1249
    -- upvalues: LocalPlayer (copy), Pather (copy), HandleMoveTo (copy)
    local Character = LocalPlayer.Character;

    if Character == nil then
        return false;
    end;

    local v249 = Pather(p246, Vector3.new(0, 1, 0), p248);

    if not (v249 and v249:IsValidPath()) then
        return false;
    end;

    HandleMoveTo(v249, p246, nil, Character, p247);

    return true;
end;

return u166;