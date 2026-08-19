-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CommonUtils = script.Parent.Parent.Parent:WaitForChild("CommonUtils");
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"));
local CameraWrapper = require(CommonUtils:WaitForChild("CameraWrapper"));
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"));
local u1 = FlagUtil.getUserFlag("UserCurrentCameraUpdate2");
local u2 = FlagUtil.getUserFlag("UserPlayerConnectionMemoryLeak");
local u3;

if u1 then
    u3 = CameraWrapper.new();
else
    u3 = nil;
end;

local u4;

if u1 then
    u4 = nil;
else
    u4 = game.Workspace.CurrentCamera;
end;

if u1 then
    u3:Enable();
end;

local min = math.min;
local tan = math.tan;
local rad = math.rad;
local _ = Ray.new;
local u5 = RaycastParams.new();
u5.IgnoreWater = true;
u5.FilterType = Enum.RaycastFilterType.Exclude;
u5.RespectCanCollide = true;
u5.CollisionGroup = "Players";
local u6 = RaycastParams.new();
u6.IgnoreWater = true;
u6.FilterType = Enum.RaycastFilterType.Include;
local u7;

if u2 then
    u7 = ConnectionUtil.new();
else
    u7 = nil;
end;

local u8 = nil;
local u9 = (1 / 0);
local u10 = "";
local u11 = nil;
local u12 = nil;

local function _debugResetLimiter() -- Line: 54
    -- upvalues: u8 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref)
    u8 = nil;
    u9 = (1 / 0);
    u10 = "";
    u11 = nil;
    u12 = nil;
end;

local function _debugConsiderLimiter(p13, p14, p15, p16, p17) -- Line: 62
end;

local function _debugFlushLimiter(p18, p19) -- Line: 78
end;

local function getTotalTransparency(p20) -- Line: 109
    return 1 - (1 - p20.Transparency) * (1 - p20.LocalTransparencyModifier);
end;

local function eraseFromEnd(p21, p22) -- Line: 113
    for i = #p21, p22 + 1, -1 do
        p21[i] = nil;
    end;
end;

local u23 = nil;
local u24 = nil;
local u25;

if u1 then
    local function updateProjection() -- Line: 123
        -- upvalues: u3 (copy), rad (copy), u24 (ref), tan (copy), u23 (ref)
        local v26 = u3:getCamera();
        local v27 = rad(v26.FieldOfView);
        local ViewportSize = v26.ViewportSize;
        local v28 = ViewportSize.X / ViewportSize.Y;
        u24 = tan(v27 / 2) * 2;
        u23 = v28 * u24;
    end;

    u3:Connect("FieldOfView", updateProjection);
    u3:Connect("ViewportSize", updateProjection);
    local v29 = u3:getCamera();
    local v30 = rad(v29.FieldOfView);
    local ViewportSize = v29.ViewportSize;
    local v31 = ViewportSize.X / ViewportSize.Y;
    u24 = tan(v30 / 2) * 2;
    u23 = v31 * u24;
    u25 = u3:getCamera().NearPlaneZ;
    u3:Connect("NearPlaneZ", function() -- Line: 139
        -- upvalues: u25 (ref), u3 (copy)
        u25 = u3:getCamera().NearPlaneZ;
    end);
else
    local function v34() -- Line: 145
        -- upvalues: u4 (ref), rad (copy), u24 (ref), tan (copy), u23 (ref)
        local v32 = rad(u4.FieldOfView);
        local ViewportSize = u4.ViewportSize;
        local v33 = ViewportSize.X / ViewportSize.Y;
        u24 = tan(v32 / 2) * 2;
        u23 = v33 * u24;
    end;

    u4:GetPropertyChangedSignal("FieldOfView"):Connect(v34);
    u4:GetPropertyChangedSignal("ViewportSize"):Connect(v34);
    local v35 = rad(u4.FieldOfView);
    local ViewportSize = u4.ViewportSize;
    local v36 = ViewportSize.X / ViewportSize.Y;
    u24 = tan(v35 / 2) * 2;
    u23 = v36 * u24;
    u25 = u4.NearPlaneZ;
    u4:GetPropertyChangedSignal("NearPlaneZ"):Connect(function() -- Line: 159
        -- upvalues: u25 (ref), u4 (ref)
        u25 = u4.NearPlaneZ;
    end);
end;

local u37 = {};
local u38 = {};

local function refreshIgnoreList() -- Line: 168
    -- upvalues: u37 (ref), u38 (copy)
    local v39 = 1;
    u37 = {};

    for _, v in pairs(u38) do
        u37[v39] = v;
        v39 = v39 + 1;
    end;
end;

local function playerAdded(u40) -- Line: 177
    -- upvalues: u38 (copy), u37 (ref), u2 (copy), u7 (copy)
    local function characterAdded(p41) -- Line: 178
        -- upvalues: u38 (ref), u40 (copy), u37 (ref)
        u38[u40] = p41;
        local v42 = 1;
        u37 = {};

        for _, v in pairs(u38) do
            u37[v42] = v;
            v42 = v42 + 1;
        end;
    end;

    local function characterRemoving() -- Line: 182
        -- upvalues: u38 (ref), u40 (copy), u37 (ref)
        u38[u40] = nil;
        local v43 = 1;
        u37 = {};

        for _, v in pairs(u38) do
            u37[v43] = v;
            v43 = v43 + 1;
        end;
    end;

    if u2 then
        u7:trackConnection(`{u40.UserId}CharacterAdded`, u40.CharacterAdded:Connect(characterAdded));
        u7:trackConnection(`{u40.UserId}CharacterRemoving`, u40.CharacterRemoving:Connect(characterRemoving));
    else
        u40.CharacterAdded:Connect(characterAdded);
        u40.CharacterRemoving:Connect(characterRemoving);
    end;

    if u40.Character then
        u38[u40] = u40.Character;
        local v44 = 1;
        u37 = {};

        for _, v in pairs(u38) do
            u37[v44] = v;
            v44 = v44 + 1;
        end;
    end;
end;

local function playerRemoving(p45) -- Line: 200
    -- upvalues: u38 (copy), u37 (ref), u2 (copy), u7 (copy)
    u38[p45] = nil;
    local v46 = 1;
    u37 = {};

    for _, v in pairs(u38) do
        u37[v46] = v;
        v46 = v46 + 1;
    end;

    if u2 then
        u7:disconnect((`{p45.UserId}CharacterAdded`));
        u7:disconnect((`{p45.UserId}CharacterRemoving`));
    end;
end;

Players.PlayerAdded:Connect(playerAdded);
Players.PlayerRemoving:Connect(playerRemoving);

for _, v in ipairs(Players:GetPlayers()) do
    playerAdded(v);
end;

local v47 = 1;
u37 = {};

for _, v in pairs(u38) do
    u37[v47] = v;
    v47 = v47 + 1;
end;

local u48 = nil;
local u49 = nil;

if u1 then
    u3:Connect("CameraSubject", function() -- Line: 240
        -- upvalues: u3 (copy), u49 (ref)
        local CameraSubject = u3:getCamera().CameraSubject;

        if CameraSubject and CameraSubject:IsA("Humanoid") then
            u49 = CameraSubject.RootPart;

            return;
        end;

        if CameraSubject and CameraSubject:IsA("BasePart") then
            u49 = CameraSubject;

            return;
        end;

        u49 = nil;
    end);
else
    u4:GetPropertyChangedSignal("CameraSubject"):Connect(function() -- Line: 251
        -- upvalues: u4 (ref), u49 (ref)
        local CameraSubject = u4.CameraSubject;

        if CameraSubject:IsA("Humanoid") then
            u49 = CameraSubject.RootPart;

            return;
        end;

        if CameraSubject:IsA("BasePart") then
            u49 = CameraSubject;

            return;
        end;

        u49 = nil;
    end);
end;

local function canOcclude(p50) -- Line: 263
    -- upvalues: u48 (ref)
    local v51;

    if 1 - (1 - p50.Transparency) * (1 - p50.LocalTransparencyModifier) < 0.25 then
        v51 = p50.CanCollide;

        if v51 then
            if u48 == (p50:GetRootPart() or p50) then
                v51 = false;
            else
                v51 = not p50:IsA("TrussPart");
            end;
        end;
    else
        v51 = false;
    end;

    return v51;
end;

local u52 = {
    Vector2.new(0.4, 0),
    Vector2.new(-0.4, 0),
    Vector2.new(0, -0.4),
    Vector2.new(0, 0.4),
    Vector2.new(0, 0.2)
};

local function getCollisionPoint(p53, p54) -- Line: 291
    -- upvalues: u5 (copy), u37 (ref)
    u5.FilterDescendantsInstances = u37;

    while true do
        local v55 = workspace:Raycast(p53, p54, u5);

        if v55 then
            if v55.Instance.CanCollide then
                return v55.Position, true;
            end;

            u5:AddToFilter(v55.Instance);
        end;

        if not v55 then
            return p53 + p54, false;
        end;
    end;
end;

local function queryPoint(p56, p57, p58, p59) -- Line: 329
    -- upvalues: u37 (ref), u25 (ref), u5 (copy), u48 (ref), u6 (copy)
    debug.profilebegin("queryPoint");
    local _ = #u37;
    local v60 = p58 + u25;
    local v61 = p56 + p57 * v60;
    u5.FilterDescendantsInstances = u37;
    local v62 = p56;
    local v63 = 0;
    local v64 = (1 / 0);
    local v65 = (1 / 0);
    local v66;

    while true do
        local v67 = workspace:Raycast(p56, v61 - p56, u5);

        if not v67 then
            v66 = v65;
            break;
        end;

        v63 = v63 + 1;
        local Instance = v67.Instance;
        local Position = v67.Position;
        v66 = (Position - v62).Magnitude;

        if v63 >= 64 then
            local _ = v66 - u25;
        else
            local v68;

            if 1 - (1 - Instance.Transparency) * (1 - Instance.LocalTransparencyModifier) < 0.25 then
                v68 = Instance.CanCollide;

                if v68 then
                    if u48 == (Instance:GetRootPart() or Instance) then
                        v68 = false;
                    else
                        v68 = not Instance:IsA("TrussPart");
                    end;
                end;
            else
                v68 = false;
            end;

            if v68 then
                u6.FilterDescendantsInstances = { Instance };

                if workspace:Raycast(v61, Position - v61, u6) then
                    local v69;

                    if p59 then
                        v69 = workspace:Raycast(p59, v61 - p59, u6) or workspace:Raycast(v61, p59 - v61, u6);
                    else
                        v69 = false;
                    end;

                    if v69 then
                        local _ = v66 - u25;
                    elseif v60 < v64 then
                        local _ = v66 - u25;
                        v64 = v66;
                        v66 = v65;
                    else
                        v66 = v65;
                    end;
                else
                    local _ = v66 - u25;
                end;
            else
                v66 = v65;
            end;
        end;

        u5:AddToFilter(Instance);
        p56 = Position - p57 * 0.001;

        if v66 < (1 / 0) or not Instance then
            break;
        end;

        v65 = v66;
    end;

    debug.profileend();

    return v64 - u25, v66 - u25;
end;

local function queryViewport(p70, p71) -- Line: 438
    -- upvalues: u4 (ref), u1 (copy), u3 (copy), u23 (ref), u24 (ref), u25 (ref), queryPoint (copy)
    debug.profilebegin("queryViewport");
    local p = p70.p;
    local rightVector = p70.rightVector;
    local upVector = p70.upVector;
    local v72 = -p70.lookVector;
    local v73;

    if u1 then
        v73 = u3:getCamera();
    else
        v73 = u4;
    end;

    u4 = v73;
    local ViewportSize = u4.ViewportSize;
    local v74 = (1 / 0);
    local v75 = (1 / 0);

    for i = 0, 1 do
        local v76 = rightVector * ((i - 0.5) * u23);

        for i2 = 0, 1 do
            local v77, v78 = queryPoint(p + u25 * (v76 + upVector * ((i2 - 0.5) * u24)), v72, p71, u4:ViewportPointToRay(ViewportSize.x * i, ViewportSize.y * i2).Origin);

            if v78 >= v74 then
                v78 = v74;
            end;

            if v77 < v75 then
                v75 = v77;
                v74 = v78;
            else
                v74 = v78;
            end;
        end;
    end;

    debug.profileend();

    return v75, v74;
end;

local function testPromotion(p79, p80, p81) -- Line: 481
    -- upvalues: getCollisionPoint (copy), min (copy), queryPoint (copy), u52 (copy)
    debug.profilebegin("testPromotion");
    local p = p79.p;
    local rightVector = p79.rightVector;
    local upVector = p79.upVector;
    local v82 = -p79.lookVector;
    debug.profilebegin("extrapolate");
    local Magnitude = (getCollisionPoint(p, p81.posVelocity * 1.25) - p).Magnitude;

    for i = 0, min(1.25, p81.rotVelocity.magnitude + Magnitude / p81.posVelocity.magnitude), 0.0625 do
        local v83 = p81.extrapolate(i);

        if p80 <= queryPoint(v83.p, -v83.lookVector, p80) then
            return false;
        end;
    end;

    debug.profileend();
    debug.profilebegin("testOffsets");

    for _, v in ipairs(u52) do
        local v84 = getCollisionPoint(p, rightVector * v.x + upVector * v.y);

        if queryPoint(v84, (p + v82 * p80 - v84).Unit, p80) == (1 / 0) then
            return false;
        end;
    end;

    debug.profileend();
    debug.profileend();

    return true;
end;

return function(p85, p86, p87) -- Line: 530, Name: Popper
    -- upvalues: u8 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref), u48 (ref), u49 (ref), queryViewport (copy), testPromotion (copy)
    debug.profilebegin("popper");
    u8 = nil;
    u9 = (1 / 0);
    u10 = "";
    u11 = nil;
    u12 = nil;
    u48 = u49 and u49:GetRootPart() or u49;
    local v88, v89 = queryViewport(p85, p86);

    if v89 >= p86 then
        v89 = p86;
    end;

    if v88 < v89 then
        if not testPromotion(p85, p86, p87) then
            v88 = v89;
        end;
    else
        v88 = v89;
    end;

    u48 = nil;
    debug.profileend();

    return v88;
end;