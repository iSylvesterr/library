-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 1
};
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local CutsceneGate = require(ReplicatedStorage.ClientModules.CutsceneGate);
local LocalPlayer = Players.LocalPlayer;
local Gardens = workspace:WaitForChild("Gardens");
local u2 = nil;
local u3 = 0;
local u4 = nil;
local u5 = {};
local u6 = {};

function v1.Init(p7) -- Line: 31
end;

function v1.Start(u8) -- Line: 34
    -- upvalues: UserInputService (copy), u2 (ref), LocalPlayer (copy), Networking (copy)
    UserInputService.InputBegan:Connect(function(p9, p10) -- Line: 35
        -- upvalues: u2 (ref), u8 (copy)
        if p10 then
            return;
        end;

        if not u2 then
            return;
        end;

        if p9.UserInputType == Enum.UserInputType.MouseButton1 and true or p9.KeyCode == Enum.KeyCode.ButtonR2 then
            u8:ProcessSwing();
        end;
    end);
    UserInputService.TouchTapInWorld:Connect(function(p11, p12) -- Line: 47
        -- upvalues: u2 (ref), u8 (copy)
        if p12 then
            return;
        end;

        if not u2 then
            return;
        end;

        u8:ProcessSwing();
    end);
    local Character = LocalPlayer.Character;

    if Character then
        u8:SetupCharacter(Character);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p13) -- Line: 57
        -- upvalues: u8 (copy)
        u8:SetupCharacter(p13);
    end);
    Networking.Crowbar.DoorForced.OnClientEvent:Connect(function(p14, p15, p16) -- Line: 61
        -- upvalues: u8 (copy)
        u8:HandleDoorForced(p14, p15, p16);
    end);
end;

function v1.SetupCharacter(p17, p18) -- Line: 69
    -- upvalues: u2 (ref)
    for _, child in p18:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("Crowbar") then
            u2 = child;
        end;
    end;

    p18.ChildAdded:Connect(function(p19) -- Line: 76
        -- upvalues: u2 (ref)
        if p19:IsA("Tool") and p19:GetAttribute("Crowbar") then
            u2 = p19;
        end;
    end);
    p18.ChildRemoved:Connect(function(p20) -- Line: 82
        -- upvalues: u2 (ref)
        if p20:IsA("Tool") and (p20:GetAttribute("Crowbar") and u2 == p20) then
            u2 = nil;
        end;
    end);
end;

function v1.FindPropByIds(p21, p22, p23) -- Line: 94
    -- upvalues: Players (copy), Gardens (copy)
    local v24 = Players:GetPlayerByUserId(p22);

    if not v24 then
        return nil;
    end;

    local v25 = v24:GetAttribute("PlotId");

    if not v25 then
        return nil;
    end;

    local v26 = Gardens:FindFirstChild("Plot" .. tostring(v25));

    if not v26 then
        return nil;
    end;

    local Props = v26:FindFirstChild("Props");

    if not Props then
        return nil;
    end;

    for _, child in Props:GetChildren() do
        if child:GetAttribute("PropId") == p23 then
            return child;
        end;
    end;

    return nil;
end;

function v1.FindPropModel(p27, p28) -- Line: 116
    local Parent = p28.Parent;

    while Parent and Parent ~= workspace do
        if Parent:IsA("Model") and Parent:GetAttribute("PropId") then
            return Parent;
        end;

        Parent = Parent.Parent;
    end;

    return nil;
end;

function v1.IsDoorPryable(p29, p30) -- Line: 130
    -- upvalues: LocalPlayer (copy)
    if p30:GetAttribute("ForcedOpen") then
        return false;
    end;

    local v31 = p30:GetAttribute("UserId");

    return (not v31 or v31 ~= LocalPlayer.UserId) and true or false;
end;

function v1.HandleDoorForced(p32, p33, p34, p35) -- Line: 146
    -- upvalues: u6 (copy), CollectionService (copy)
    local u36 = p32:FindPropByIds(p33, p34);

    if not u36 then
        return;
    end;

    if u6[u36] then
        task.cancel(u6[u36]);
        u6[u36] = nil;
    end;

    u36:SetAttribute("ForcedOpen", true);
    local v37 = {};
    local v38 = nil;

    for _, descendant in u36:GetDescendants() do
        if descendant:IsA("BasePart") and CollectionService:HasTag(descendant, "CrowbarDoor") then
            table.insert(v37, descendant.Color);

            if not v38 then
                v38 = descendant.Position;
            end;
        end;
    end;

    u6[u36] = task.delay(p35, function() -- Line: 168
        -- upvalues: u6 (ref), u36 (copy)
        u6[u36] = nil;

        if u36 and u36.Parent then
            u36:SetAttribute("ForcedOpen", false);
        end;
    end);
end;

function v1.HandleDoorForced(p39, p40, p41, p42) -- Line: 175
    -- upvalues: Players (copy), Gardens (copy), u6 (copy), CollectionService (copy)
    local u43 = p39:FindPropByIds(p40, p41);

    if not u43 then
        local v44 = Players:GetPlayerByUserId(p40);

        if not v44 then
            return;
        end;

        local v45 = v44:GetAttribute("PlotId");

        if v45 then
            local v46 = Gardens:FindFirstChild("Plot" .. tostring(v45));
            local v47 = v46 and v46:FindFirstChild("Props");

            if v47 then
                for _, _ in v47:GetChildren() do

                end;

                return;
            end;
        end;

        return;
    end;

    if u6[u43] then
        task.cancel(u6[u43]);
        u6[u43] = nil;
    end;

    u43:SetAttribute("ForcedOpen", true);
    local v48 = {};
    local v49 = nil;

    for _, descendant in u43:GetDescendants() do
        if descendant:IsA("BasePart") and CollectionService:HasTag(descendant, "CrowbarDoor") then
            table.insert(v48, descendant.Color);

            if not v49 then
                v49 = descendant.Position;
            end;
        end;
    end;

    u6[u43] = task.delay(p42, function() -- Line: 218
        -- upvalues: u6 (ref), u43 (copy)
        u6[u43] = nil;

        if u43 and u43.Parent then
            u43:SetAttribute("ForcedOpen", false);
        end;
    end);
end;

function v1.PlaySwingAnimation(p50) -- Line: 228
    -- upvalues: LocalPlayer (copy), u4 (ref)
    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    local v51 = Character:FindFirstChildOfClass("Humanoid");

    if not v51 then
        return;
    end;

    local v52 = v51:FindFirstChildOfClass("Animator");

    if not v52 then
        return;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = "rbxassetid://78592768207309";
    u4 = v52:LoadAnimation(Animation);
    u4.Looped = false;
    u4.Priority = Enum.AnimationPriority.Action4;
    u4:Play();
end;

function v1.ProcessSwing(p53) -- Line: 244
    -- upvalues: CutsceneGate (copy), u2 (ref), u3 (ref), Networking (copy)
    if CutsceneGate.IsActive() then
        return;
    end;

    if not u2 then
        return;
    end;

    local v54 = os.clock();

    if v54 - u3 < 1 then
        return;
    end;

    u3 = v54;
    p53:PlaySwingAnimation();
    Networking.Crowbar.SwingCrowbar:Fire();
    p53:ActivateHitDetection();
end;

function v1.ActivateHitDetection(u55) -- Line: 265
    -- upvalues: u2 (ref), LocalPlayer (copy), CollectionService (copy), Networking (copy), Players (copy), u5 (copy)
    local v56 = u2;

    if not v56 then
        return;
    end;

    local v57 = LocalPlayer:GetAttribute("IsInOwnGarden") and "NormalCollision" or "GardenCollision";
    local v58 = {};
    local v59 = {};
    local u60 = {};
    local u61 = {};
    local u62 = 0;
    local u63 = {};

    for _, descendant in v56:GetDescendants() do
        if descendant:IsA("BasePart") then
            if descendant.Name == v57 then
                table.insert(v58, descendant.Name);
            else
                table.insert(v59, descendant);
            end;
        end;
    end;

    for _, _ in v59 do

    end;

    if #v59 == 0 then
        for _, _ in v56:GetDescendants() do

        end;
    end;

    for _, v in v59 do
        local v71 = v.Touched:Connect(function(p64) -- Line: 301
            -- upvalues: u62 (ref), CollectionService (ref), u55 (copy), u63 (copy), Networking (ref), Players (ref), LocalPlayer (ref), u60 (copy), u5 (ref)
            if not p64:IsA("BasePart") then
                return;
            end;

            u62 = u62 + 1;

            if CollectionService:HasTag(p64, "CrowbarDoor") then
                local v65 = u55:FindPropModel(p64);

                if not v65 then
                    return;
                end;

                if u63[v65] then
                    return;
                end;

                if not u55:IsDoorPryable(v65) then
                    return;
                end;

                u63[v65] = true;
                local v66 = v65:GetAttribute("UserId");
                local v67 = v65:GetAttribute("PropId");

                if not (v66 and v67) then
                    return;
                end;

                Networking.Crowbar.PryDoor:Fire(v66, v67);

                return;
            end;

            local v68 = p64:FindFirstAncestorWhichIsA("Model");

            if not v68 then
                return;
            end;

            local v69 = Players:GetPlayerFromCharacter(v68);

            if not v69 or v69 == LocalPlayer then
                return;
            end;

            if u60[v69] then
                return;
            end;

            local v70 = os.clock();

            if u5[v69] and v70 - u5[v69] < 0.5 then
                return;
            end;

            u60[v69] = true;
            u5[v69] = v70;
            Networking.Crowbar.HitPlayer:Fire(v69.UserId);
        end);
        table.insert(u61, v71);
    end;

    task.delay(0.4, function() -- Line: 353
        -- upvalues: u61 (copy)
        for _, v in u61 do
            v:Disconnect();
        end;
    end);
end;

return v1;