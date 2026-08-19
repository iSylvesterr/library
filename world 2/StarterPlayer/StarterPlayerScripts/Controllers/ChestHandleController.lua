-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Chests = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Chests");
local ChestData = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("ChestData"));
local BackpackListener = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("BackpackListener"));
local HeldHandleSelfHeal = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HeldHandleSelfHeal"));
local HandleScale = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HandleScale"));
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = CFrame.new(0, 0, 1);
local u6 = CFrame.new(0, -1, 0) * CFrame.Angles(-1.5707963267948966, 0, 0);

local function ResolveChestTemplate(p7) -- Line: 30
    -- upvalues: ChestData (copy), Chests (copy)
    local v8 = ChestData.GetData(p7);

    if v8 then
        v8 = v8.Model;
    end;

    if v8 then
        local v9 = Chests:FindFirstChild(v8);

        if v9 and v9:IsA("Model") then
            return v9;
        end;
    end;

    local v10 = Chests:FindFirstChild(p7);

    if v10 and v10:IsA("Model") then
        return v10;
    end;

    return nil;
end;

local function ResolveGripAngles(p11) -- Line: 53
    -- upvalues: ChestData (copy)
    local v12 = ChestData.GetData(p11);

    if v12 then
        v12 = v12.GripAngles;
    end;

    if typeof(v12) == "Vector3" then
        return CFrame.Angles(math.rad(v12.X), math.rad(v12.Y), (math.rad(v12.Z)));
    end;

    return CFrame.identity;
end;

function v1.Init(p13) -- Line: 66
end;

function v1.Start(u14) -- Line: 70
    -- upvalues: Players (copy), u2 (copy)
    for _, v in Players:GetPlayers() do
        u14:SetupPlayer(v);
    end;

    Players.PlayerAdded:Connect(function(p15) -- Line: 76
        -- upvalues: u14 (copy)
        u14:SetupPlayer(p15);
    end);
    Players.PlayerRemoving:Connect(function(p16) -- Line: 81
        -- upvalues: u2 (ref), Players (ref), u14 (copy)
        for i in u2 do
            local v17 = Players:GetPlayerFromCharacter(i.Parent) or i.Parent and i.Parent:IsA("Backpack") and Players:GetPlayerFromCharacter(i.Parent.Parent);

            if v17 == p16 then
                u14:CleanupTool(i);
            end;
        end;
    end);
end;

function v1.PreparePartForTool(p18, p19) -- Line: 93
    p19.Anchored = false;
    p19.CanCollide = false;
    p19.CanQuery = false;
    p19.CanTouch = false;
end;

function v1.DisableVFX(p20, p21) -- Line: 101
    for _, descendant in p21:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
            descendant.Enabled = false;
        elseif descendant:IsA("Fire") or (descendant:IsA("Smoke") or descendant:IsA("Sparkles")) then
            descendant.Enabled = false;
        elseif descendant:IsA("Light") then
            descendant.Enabled = false;
        end;
    end;
end;

function v1.StripRig(p22, p23) -- Line: 114
    for _, descendant in p23:GetDescendants() do
        if descendant:IsA("Motor6D") or descendant:IsA("AnimationController") then
            descendant:Destroy();
        end;
    end;
end;

function v1.ClearHandle(p24, p25) -- Line: 123
    for _, child in p25:GetChildren() do
        if child.Name == "Handle" or (child.Name == "Build" or child:IsA("Model")) then
            child.Parent = nil;
            task.defer(function() -- Line: 127
                -- upvalues: child (copy)
                if child then
                    child:Destroy();
                end;
            end);
        end;
    end;
end;

function v1.HasHandle(p26, p27) -- Line: 137
    for _, child in p27:GetChildren() do
        if child.Name == "Handle" then
            return true;
        end;
    end;

    return false;
end;

function v1.SpawnHandle(u28, u29, p30) -- Line: 147
    -- upvalues: u4 (copy), ResolveChestTemplate (copy), HandleScale (copy), LocalPlayer (copy), ChestData (copy), u5 (copy), u6 (copy), HeldHandleSelfHeal (copy), u3 (copy)
    if u4[u29] then
        return;
    end;

    u4[u29] = true;
    u28:ClearHandle(u29);
    local v31 = p30:FindFirstChild("Right Arm") or p30:FindFirstChild("RightHand");

    if not v31 then
        u4[u29] = nil;

        return;
    end;

    local v32 = u29:GetAttribute("Chest");

    if not v32 then
        u4[u29] = nil;

        return;
    end;

    local v33 = ResolveChestTemplate(v32);

    if not v33 then
        u4[u29] = nil;

        return;
    end;

    local v34 = v33:Clone();
    u28:DisableVFX(v34);
    u28:StripRig(v34);
    local v35 = p30:GetScale();
    HandleScale.ScaleClone(v34, v35);
    local v36 = LocalPlayer and LocalPlayer.Character == p30;
    local PrimaryPart = v34.PrimaryPart;

    if not PrimaryPart then
        v34:Destroy();
        u4[u29] = nil;

        return;
    end;

    for _, descendant in v34:GetDescendants() do
        if descendant:IsA("BasePart") then
            u28:PreparePartForTool(descendant);
        end;
    end;

    local v37 = ChestData.GetData(v32);

    if v37 and v37.RainbowModel then
        v34:AddTag("RainbowModel");
    end;

    for _, descendant in v34:GetDescendants() do
        if descendant:IsA("BasePart") and descendant ~= PrimaryPart then
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = PrimaryPart;
            WeldConstraint.Part1 = descendant;
            WeldConstraint.Parent = descendant;
        end;
    end;

    v34.Name = "Build";
    v34.Parent = u29;
    PrimaryPart.Name = "Handle";
    PrimaryPart.Parent = u29;
    local v38 = ChestData.GetData(v32);

    if v38 then
        v38 = v38.GripAngles;
    end;

    local v39;

    if typeof(v38) == "Vector3" then
        v39 = CFrame.Angles(math.rad(v38.X), math.rad(v38.Y), (math.rad(v38.Z)));
    else
        v39 = CFrame.identity;
    end;

    if v36 then
        u29.Grip = v39 * HandleScale.ScaleGripTranslation(u5, v35);
    else
        PrimaryPart.CFrame = v31.CFrame * HandleScale.ScaleGripTranslation(u6, v35) * v39;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = PrimaryPart;
        WeldConstraint.Part1 = v31;
        WeldConstraint.Parent = PrimaryPart;
    end;

    local Handle = u29:FindFirstChild("Handle");

    if Handle then
        HeldHandleSelfHeal.WatchHandle(u29, Handle, function() -- Line: 247
            -- upvalues: u3 (ref), u29 (copy)
            return u3[u29];
        end, function() -- Line: 248
            -- upvalues: u28 (copy), u29 (copy)
            return u28:HasHandle(u29);
        end, function() -- Line: 249
            -- upvalues: u3 (ref), u29 (copy), u28 (copy)
            local v40 = u3[u29];

            if v40 then
                u28:SpawnHandle(u29, v40);
            end;
        end);
    end;

    u4[u29] = nil;
end;

function v1.UpdateToolState(p41, p42) -- Line: 260
    -- upvalues: u4 (copy), u3 (copy)
    if u4[p42] then
        return;
    end;

    local v43 = u3[p42];

    if not v43 then
        return;
    end;

    local v44 = p42.Parent == v43;
    local v45 = p41:HasHandle(p42);

    if v44 and not v45 then
        p41:SpawnHandle(p42, v43);

        return;
    end;

    if not v44 and v45 then
        p41:ClearHandle(p42);
    end;
end;

function v1.DisconnectTool(p46, p47) -- Line: 280
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local v48 = u2[p47];

    if v48 then
        for _, v in v48 do
            v:Disconnect();
        end;

        u2[p47] = nil;
    end;

    u3[p47] = nil;
    u4[p47] = nil;
end;

function v1.CleanupTool(p49, p50) -- Line: 295
    p49:ClearHandle(p50);
    p49:DisconnectTool(p50);
end;

function v1.IsTrackedTool(p51, p52) -- Line: 301
    return p52:GetAttribute("Chest") ~= nil;
end;

function v1.SetupTool(u53, u54, p55) -- Line: 306
    -- upvalues: u3 (copy), u2 (copy)
    u53:DisconnectTool(u54);
    local v56 = {};
    u3[u54] = p55;
    local v57 = u54:GetPropertyChangedSignal("Parent");
    table.insert(v56, v57:Connect(function() -- Line: 314
        -- upvalues: u54 (copy), u3 (ref), u53 (copy)
        task.defer(function() -- Line: 315
            -- upvalues: u54 (ref), u3 (ref), u53 (ref)
            if u54 and u3[u54] then
                u53:UpdateToolState(u54);
            end;
        end);
    end));
    u2[u54] = v56;
    task.defer(function() -- Line: 326
        -- upvalues: u54 (copy), u3 (ref), u53 (copy)
        if u54 and u3[u54] then
            u53:UpdateToolState(u54);
        end;
    end);
end;

function v1.SetupCharacter(u58, u59) -- Line: 334
    -- upvalues: Players (copy), HandleScale (copy)
    task.defer(function() -- Line: 335
        -- upvalues: u59 (copy), u58 (copy), Players (ref), HandleScale (ref)
        if not (u59 and u59.Parent) then
            return;
        end;

        for _, child in u59:GetChildren() do
            if child:IsA("Tool") and u58:IsTrackedTool(child) then
                u58:SetupTool(child, u59);
            end;
        end;

        local v60 = Players:GetPlayerFromCharacter(u59);

        if v60 and v60.Backpack then
            for _, child in v60.Backpack:GetChildren() do
                if child:IsA("Tool") and u58:IsTrackedTool(child) then
                    u58:SetupTool(child, u59);
                end;
            end;
        end;

        u59.ChildAdded:Connect(function(u61) -- Line: 356
            -- upvalues: u58 (ref), u59 (ref)
            if u61:IsA("Tool") and u58:IsTrackedTool(u61) then
                task.defer(function() -- Line: 358
                    -- upvalues: u61 (copy), u59 (ref), u58 (ref)
                    if u61 and (u61.Parent and (u59 and u59.Parent)) then
                        u58:SetupTool(u61, u59);
                    end;
                end);
            end;
        end);
        HandleScale.MonitorCharacterScale(u59, function(p62) -- Line: 368
            -- upvalues: u58 (ref)
            return u58:IsTrackedTool(p62);
        end, function(p63, p64) -- Line: 369
            -- upvalues: u58 (ref)
            u58:SpawnHandle(p63, p64);
        end);
    end);
end;

function v1.SetupPlayer(u65, u66) -- Line: 374
    -- upvalues: BackpackListener (copy)
    if u66.Character then
        u65:SetupCharacter(u66.Character);
    end;

    u66.CharacterAdded:Connect(function(p67) -- Line: 380
        -- upvalues: u65 (copy)
        u65:SetupCharacter(p67);
    end);
    BackpackListener.bind(u66, function(u68) -- Line: 385
        -- upvalues: u65 (copy), u66 (copy)
        if u68:IsA("Tool") and u65:IsTrackedTool(u68) then
            task.defer(function() -- Line: 387
                -- upvalues: u66 (ref), u68 (copy), u65 (ref)
                local Character = u66.Character;

                if u68 and (u68.Parent and (Character and Character.Parent)) then
                    u65:SetupTool(u68, Character);
                end;
            end);
        end;
    end);
end;

return v1;