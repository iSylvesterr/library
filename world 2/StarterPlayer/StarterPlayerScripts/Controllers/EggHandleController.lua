-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local Eggs = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Eggs");
local BackpackListener = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("BackpackListener"));
local HeldHandleSelfHeal = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HeldHandleSelfHeal"));
local HandleScale = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("HandleScale"));
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = false;
local u6 = false;
local u7 = CFrame.new(0, 0, 0) * CFrame.Angles(0, 1.5707963267948966, 0);
local u8 = CFrame.new(0, 0, 0) * CFrame.Angles(-1.5707963267948966, 1.5707963267948966, 0);

function v1.Init(p9) -- Line: 28
end;

function v1.Start(u10) -- Line: 31
    -- upvalues: Players (copy), u2 (copy)
    for _, v in Players:GetPlayers() do
        u10:SetupPlayer(v);
    end;

    Players.PlayerAdded:Connect(function(p11) -- Line: 36
        -- upvalues: u10 (copy)
        u10:SetupPlayer(p11);
    end);
    Players.PlayerRemoving:Connect(function(p12) -- Line: 40
        -- upvalues: u2 (ref), Players (ref), u10 (copy)
        for i in u2 do
            local v13 = Players:GetPlayerFromCharacter(i.Parent) or i.Parent and i.Parent:IsA("Backpack") and Players:GetPlayerFromCharacter(i.Parent.Parent);

            if v13 == p12 then
                u10:CleanupTool(i);
            end;
        end;
    end);
end;

function v1.PreparePartForTool(p14, p15) -- Line: 51
    p15.Anchored = false;
    p15.CanCollide = false;
    p15.CanQuery = false;
    p15.CanTouch = false;
end;

function v1.DisableVFX(p16, p17) -- Line: 58
    for _, descendant in p17:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or descendant:IsA("Beam")) then
            descendant.Enabled = false;
        elseif descendant:IsA("Fire") or (descendant:IsA("Smoke") or descendant:IsA("Sparkles")) then
            descendant.Enabled = false;
        elseif descendant:IsA("Light") then
            descendant.Enabled = false;
        end;
    end;
end;

function v1.ClearVisual(p18, p19) -- Line: 70
    for _, child in p19:GetChildren() do
        if child:GetAttribute("_EggVisual") then
            child.Parent = nil;
            task.defer(function() -- Line: 74
                -- upvalues: child (copy)
                if child then
                    child:Destroy();
                end;
            end);
        end;
    end;
end;

function v1.HasVisual(p20, p21) -- Line: 83
    for _, child in p21:GetChildren() do
        if child:GetAttribute("_EggVisual") then
            return true;
        end;
    end;

    return false;
end;

function v1.SpawnHandle(u22, u23, p24) -- Line: 92
    -- upvalues: u4 (copy), Eggs (copy), HandleScale (copy), LocalPlayer (copy), u7 (copy), u8 (copy), HeldHandleSelfHeal (copy), u3 (copy)
    if u4[u23] then
        return;
    end;

    u4[u23] = true;
    u22:ClearVisual(u23);
    local Handle = u23:FindFirstChild("Handle");

    if not Handle then
        u4[u23] = nil;

        return;
    end;

    local v25 = p24:FindFirstChild("Right Arm") or p24:FindFirstChild("RightHand");

    if not v25 then
        u4[u23] = nil;

        return;
    end;

    local v26 = u23:GetAttribute("Egg");

    if not v26 then
        u4[u23] = nil;

        return;
    end;

    local v27 = Eggs:FindFirstChild(v26);

    if not v27 then
        u4[u23] = nil;

        return;
    end;

    local v28 = v27:Clone();
    u22:DisableVFX(v28);
    local v29 = p24:GetScale();
    HandleScale.ScaleClone(v28, v29);
    local v30 = v28.PrimaryPart or (v28:FindFirstChild("Handle") or v28:FindFirstChildWhichIsA("BasePart", true));

    if not v30 then
        v28:Destroy();
        u4[u23] = nil;

        return;
    end;

    for _, descendant in v28:GetDescendants() do
        if descendant:IsA("BasePart") then
            u22:PreparePartForTool(descendant);
        end;
    end;

    local Weld = Instance.new("Weld");
    Weld.Part0 = v30;
    Weld.Part1 = Handle;
    Weld.Parent = v30;
    v28:SetAttribute("_EggVisual", true);
    v28.Parent = u23;

    if LocalPlayer and LocalPlayer.Character == p24 then
        u23.Grip = HandleScale.ScaleGripTranslation(u7 * CFrame.new(0, -v30.Size.Y / 4, v30.Size.Z / 2), v29);
    else
        v30.CFrame = v25.CFrame * HandleScale.ScaleGripTranslation(u8, v29);
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = v30;
        WeldConstraint.Part1 = v25;
        WeldConstraint.Parent = v30;
    end;

    local Handle2 = u23:FindFirstChild("Handle");

    if Handle2 then
        HeldHandleSelfHeal.WatchHandle(u23, Handle2, function() -- Line: 164
            -- upvalues: u3 (ref), u23 (copy)
            return u3[u23];
        end, function() -- Line: 165
            -- upvalues: u22 (copy), u23 (copy)
            return u22:HasHandle(u23);
        end, function() -- Line: 166
            -- upvalues: u3 (ref), u23 (copy), u22 (copy)
            local v31 = u3[u23];

            if v31 then
                u22:SpawnHandle(u23, v31);
            end;
        end);
    end;

    u4[u23] = nil;
end;

function v1.UpdateToolState(p32, p33) -- Line: 175
    -- upvalues: u4 (copy), u3 (copy)
    if u4[p33] then
        return;
    end;

    local v34 = u3[p33];

    if not v34 then
        return;
    end;

    local v35 = p33.Parent == v34;
    local v36 = p32:HasVisual(p33);

    if v35 and not v36 then
        p32:SpawnHandle(p33, v34);

        return;
    end;

    if not v35 and v36 then
        p32:ClearVisual(p33);
    end;
end;

function v1.DisconnectTool(p37, p38) -- Line: 191
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local v39 = u2[p38];

    if v39 then
        for _, v in v39 do
            v:Disconnect();
        end;

        u2[p38] = nil;
    end;

    u3[p38] = nil;
    u4[p38] = nil;
end;

function v1.CleanupTool(p40, p41) -- Line: 203
    p40:ClearVisual(p41);
    p40:DisconnectTool(p41);
end;

function v1.IsTrackedTool(p42, p43) -- Line: 208
    return p43:GetAttribute("Egg") ~= nil;
end;

function v1.SetupTool(u44, u45, p46) -- Line: 212
    -- upvalues: u3 (copy), LocalPlayer (copy), u5 (ref), Networking (copy), u6 (ref), u2 (copy)
    u44:DisconnectTool(u45);
    local v47 = {};
    u3[u45] = p46;
    local v48 = u45:GetPropertyChangedSignal("Parent");
    table.insert(v47, v48:Connect(function() -- Line: 218
        -- upvalues: u45 (copy), u3 (ref), u44 (copy)
        task.defer(function() -- Line: 219
            -- upvalues: u45 (ref), u3 (ref), u44 (ref)
            if u45 and u3[u45] then
                u44:UpdateToolState(u45);
            end;
        end);
    end));

    local function openOnce(u49) -- Line: 226
        -- upvalues: LocalPlayer (ref), u5 (ref), Networking (ref)
        if LocalPlayer:GetAttribute("LoadingScreenActive") then
            return false;
        end;

        if u5 then
            return false;
        end;

        u5 = true;
        local success, success = pcall(function() -- Line: 231
            -- upvalues: Networking (ref), u49 (copy)
            return Networking.Egg.OpenEgg:Fire(u49);
        end);

        if not success then
            warn((`[EggHandleController] OpenEgg invoke errored ({u49}): {success}`));
        end;

        u5 = false;

        if success then
            if success then
                success = success.Success == true;
            end;
        end;

        return success;
    end;

    table.insert(v47, u45.Activated:Connect(function() -- Line: 242
        -- upvalues: u45 (copy), u6 (ref), openOnce (copy)
        local v50 = u45:GetAttribute("Egg");

        if not v50 or u6 then
            return;
        end;

        u6 = true;

        if not openOnce(v50) then
            u6 = false;

            return;
        end;

        local v51 = tick();

        while u6 and tick() - v51 < 1 do
            task.wait();
        end;

        while u6 do
            local v52 = u45:GetAttribute("Egg");

            if not (v52 and openOnce(v52)) then
                break;
            end;

            local v53 = tick();

            while u6 and tick() - v53 < 0.2 do
                task.wait();
            end;
        end;
    end));
    table.insert(v47, u45.Deactivated:Connect(function() -- Line: 273
        -- upvalues: u6 (ref)
        u6 = false;
    end));
    u2[u45] = v47;
    task.defer(function() -- Line: 279
        -- upvalues: u45 (copy), u3 (ref), u44 (copy)
        if u45 and u3[u45] then
            u44:UpdateToolState(u45);
        end;
    end);
end;

function v1.SetupCharacter(u54, u55) -- Line: 286
    -- upvalues: Players (copy), HandleScale (copy)
    task.defer(function() -- Line: 287
        -- upvalues: u55 (copy), u54 (copy), Players (ref), HandleScale (ref)
        if not (u55 and u55.Parent) then
            return;
        end;

        for _, child in u55:GetChildren() do
            if child:IsA("Tool") and u54:IsTrackedTool(child) then
                u54:SetupTool(child, u55);
            end;
        end;

        local v56 = Players:GetPlayerFromCharacter(u55);

        if v56 and v56.Backpack then
            for _, child in v56.Backpack:GetChildren() do
                if child:IsA("Tool") and u54:IsTrackedTool(child) then
                    u54:SetupTool(child, u55);
                end;
            end;
        end;

        u55.ChildAdded:Connect(function(u57) -- Line: 305
            -- upvalues: u54 (ref), u55 (ref)
            if u57:IsA("Tool") and u54:IsTrackedTool(u57) then
                task.defer(function() -- Line: 307
                    -- upvalues: u57 (copy), u55 (ref), u54 (ref)
                    if u57 and (u57.Parent and (u55 and u55.Parent)) then
                        u54:SetupTool(u57, u55);
                    end;
                end);
            end;
        end);
        HandleScale.MonitorCharacterScale(u55, function(p58) -- Line: 316
            -- upvalues: u54 (ref)
            return u54:IsTrackedTool(p58);
        end, function(p59, p60) -- Line: 317
            -- upvalues: u54 (ref)
            u54:SpawnHandle(p59, p60);
        end);
    end);
end;

function v1.SetupPlayer(u61, u62) -- Line: 321
    -- upvalues: BackpackListener (copy)
    if u62.Character then
        u61:SetupCharacter(u62.Character);
    end;

    u62.CharacterAdded:Connect(function(p63) -- Line: 326
        -- upvalues: u61 (copy)
        u61:SetupCharacter(p63);
    end);
    BackpackListener.bind(u62, function(u64) -- Line: 330
        -- upvalues: u61 (copy), u62 (copy)
        if u64:IsA("Tool") and u61:IsTrackedTool(u64) then
            task.defer(function() -- Line: 332
                -- upvalues: u62 (ref), u64 (copy), u61 (ref)
                local Character = u62.Character;

                if u64 and (u64.Parent and (Character and Character.Parent)) then
                    u61:SetupTool(u64, Character);
                end;
            end);
        end;
    end);
end;

return v1;