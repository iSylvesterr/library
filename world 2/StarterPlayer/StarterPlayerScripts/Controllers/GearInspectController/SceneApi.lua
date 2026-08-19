-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local u2 = {
    List = nil,
    Fetched = false
};

local function FetchFriendList(p3) -- Line: 18
    -- upvalues: u2 (copy), Players (copy)
    if u2.Fetched then
        return u2.List;
    end;

    u2.Fetched = true;
    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        u2.List = {};

        return u2.List;
    end;

    local success, result = pcall(function() -- Line: 29
        -- upvalues: Players (ref), LocalPlayer (copy)
        return Players:GetFriendsAsync(LocalPlayer.UserId);
    end);

    if not (success and result) then
        u2.List = {};

        return u2.List;
    end;

    local v4 = 0;
    local v5 = {};

    while v4 < p3 do
        local success2, result2 = pcall(function() -- Line: 41
            -- upvalues: result (copy)
            return result:GetCurrentPage();
        end);

        if not (success2 and result2) then
            break;
        end;

        for _, v in result2 do
            table.insert(v5, v);
            v4 = v4 + 1;

            if p3 <= v4 then
                break;
            end;
        end;

        if result.IsFinished or not pcall(function() -- Line: 51
            -- upvalues: result (copy)
            result:AdvanceToNextPageAsync();
        end) then
            break;
        end;
    end;

    u2.List = v5;

    return v5;
end;

function u1.new(p6) -- Line: 60
    -- upvalues: u1 (copy)
    local u7 = setmetatable({}, u1);
    u7.Plot = p6.Plot;
    u7.PlayerModel = p6.PlayerModel;
    u7.PlayerHumanoid = p6.PlayerHumanoid;
    u7.Camera = p6.Camera;
    u7.Trove = p6.Trove;
    u7.GearData = p6.GearData;
    u7.Options = p6.Options;
    u7.ActiveTracks = {};
    u7.ActiveCameraTween = nil;
    u7.Trove:Add(function() -- Line: 73
        -- upvalues: u7 (copy)
        for _, v in u7.ActiveTracks do
            if v then
                v:Stop(0);
            end;
        end;

        u7.ActiveTracks = {};

        if u7.ActiveCameraTween then
            u7.ActiveCameraTween:Cancel();
            u7.ActiveCameraTween = nil;
        end;
    end);

    return u7;
end;

function u1.SpawnDummy(p8, p9, p10) -- Line: 88
    -- upvalues: ReplicatedStorage (copy)
    if typeof(p9) == "string" then
        local SceneAssets = ReplicatedStorage:FindFirstChild("SceneAssets");

        if SceneAssets then
            SceneAssets = SceneAssets:FindFirstChild("Dummies");
        end;

        if SceneAssets then
            p9 = SceneAssets:FindFirstChild(p9);
        end;
    end;

    if not p9 then
        return nil;
    end;

    local v11 = p9:Clone();
    v11.Parent = p8.Plot;

    if p10 then
        local v12 = typeof(p10) == "CFrame" and p10 and p10 or CFrame.new(p10);

        if v11.PrimaryPart then
            v11:PivotTo(v12);
        end;
    end;

    p8.Trove:Add(v11);

    return v11;
end;

function u1.PlayAnimation(p13, p14, p15, p16) -- Line: 114
    local v17 = p15 or p13.PlayerHumanoid;

    if not v17 then
        return nil;
    end;

    local v18, v19;

    if typeof(p14) == "Instance" then
        v18 = p14;
        v19 = false;
    else
        v18 = Instance.new("Animation");
        v19 = true;

        if typeof(p14) == "number" then
            v18.AnimationId = `rbxassetid://{p14}`;
        else
            v18.AnimationId = tostring(p14);
        end;
    end;

    local u20 = v17:LoadAnimation(v18);

    if v19 then
        v18:Destroy();
    end;

    u20:Play(p16 or 0.1);
    table.insert(p13.ActiveTracks, u20);
    p13.Trove:Add(function() -- Line: 141
        -- upvalues: u20 (copy)
        if u20 then
            u20:Stop(0);
        end;
    end);

    return u20;
end;

function u1.SpawnProp(p21, p22, p23) -- Line: 149
    -- upvalues: ReplicatedStorage (copy)
    if typeof(p22) == "string" then
        local SceneAssets = ReplicatedStorage:FindFirstChild("SceneAssets");

        if SceneAssets then
            SceneAssets = SceneAssets:FindFirstChild("Props");
        end;

        if SceneAssets then
            p22 = SceneAssets:FindFirstChild(p22);
        end;
    end;

    if not p22 then
        return nil;
    end;

    local v24 = p22:Clone();
    v24.Parent = p21.Plot;

    if p23 then
        local v25 = typeof(p23) == "CFrame" and p23 and p23 or CFrame.new(p23);

        if v24:IsA("Model") then
            if v24.PrimaryPart then
                v24:PivotTo(v25);
            end;
        elseif v24:IsA("BasePart") then
            v24.CFrame = v25;
        end;
    end;

    p21.Trove:Add(v24);

    return v24;
end;

function u1.SetCamera(p26, p27, p28) -- Line: 179
    p26.Camera.CameraType = Enum.CameraType.Scriptable;
    p26.Camera.CFrame = p27;

    if p28 then
        p26.Camera.FieldOfView = p28;
    end;
end;

function u1.CameraShot(p29, p30, p31) -- Line: 189
    -- upvalues: TweenService (copy)
    local v32 = p31 or {};
    p29.Camera.CameraType = Enum.CameraType.Scriptable;

    if p29.ActiveCameraTween then
        p29.ActiveCameraTween:Cancel();
        p29.ActiveCameraTween = nil;
    end;

    local v33 = TweenInfo.new(v32.Duration or 1, v32.EasingStyle or Enum.EasingStyle.Quad, v32.EasingDirection or Enum.EasingDirection.InOut);
    local v34 = {
        CFrame = p30
    };

    if v32.FieldOfView then
        v34.FieldOfView = v32.FieldOfView;
    end;

    local v35 = TweenService:Create(p29.Camera, v33, v34);
    p29.ActiveCameraTween = v35;
    v35:Play();

    return v35;
end;

function u1.OrbitCamera(u36, u37, p38) -- Line: 216
    -- upvalues: RunService (copy)
    local v39 = p38 or {};
    local u40 = v39.Radius or 8;
    local u41 = v39.Height or 4;
    local u42 = v39.Speed or 0.4;
    local FieldOfView = v39.FieldOfView;
    u36.Camera.CameraType = Enum.CameraType.Scriptable;

    if FieldOfView then
        u36.Camera.FieldOfView = FieldOfView;
    end;

    local u43 = 0;
    local v48 = RunService.RenderStepped:Connect(function(p44) -- Line: 229
        -- upvalues: u43 (ref), u42 (copy), u37 (copy), u40 (copy), u41 (copy), u36 (copy)
        u43 = u43 + p44 * u42;
        local v45 = math.cos(u43) * u40;
        local v46 = math.sin(u43) * u40;
        local v47 = u37 + Vector3.new(v45, u41, v46);
        u36.Camera.CFrame = CFrame.lookAt(v47, u37);
    end);
    u36.Trove:Add(v48);

    return v48;
end;

function u1.Wait(p49, p50) -- Line: 239
    task.wait(p50);
end;

function u1.GetGearModel(p51) -- Line: 244
    return p51.GearData and (p51.GearData.Model or p51.GearData.Tool);
end;

function u1.ApplyRandomFriendAppearance(p52, p53, p54) -- Line: 249
    -- upvalues: FetchFriendList (copy), Players (copy)
    if not p53 then
        return false;
    end;

    local u55 = p53:FindFirstChildOfClass("Humanoid");

    if not u55 then
        return false;
    end;

    local v56 = FetchFriendList(p54 or 50);

    if not v56 or #v56 == 0 then
        return false;
    end;

    local u57 = v56[math.random(1, #v56)];

    if not (u57 and u57.Id) then
        return false;
    end;

    local success, result = pcall(function() -- Line: 260
        -- upvalues: Players (ref), u57 (copy)
        return Players:GetHumanoidDescriptionFromUserIdAsync(u57.Id);
    end);

    if success and result then
        return pcall(function() -- Line: 265
            -- upvalues: u55 (copy), result (copy)
            u55:ApplyDescriptionResetAsync(result);
        end);
    end;

    return false;
end;

return u1;