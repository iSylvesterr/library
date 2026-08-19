-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local BackpackListener = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("BackpackListener"));
local u2 = {};
local u3 = {};
local u4 = {};

function v1.Init(p5) -- Line: 27
end;

function v1.Start(u6) -- Line: 30
    -- upvalues: Players (copy), u2 (copy)
    for _, v in Players:GetPlayers() do
        u6:SetupPlayer(v);
    end;

    Players.PlayerAdded:Connect(function(p7) -- Line: 35
        -- upvalues: u6 (copy)
        u6:SetupPlayer(p7);
    end);
    Players.PlayerRemoving:Connect(function(p8) -- Line: 39
        -- upvalues: u2 (ref), Players (ref), u6 (copy)
        for i in u2 do
            local v9 = Players:GetPlayerFromCharacter(i.Parent) or i.Parent and i.Parent:IsA("Backpack") and Players:GetPlayerFromCharacter(i.Parent.Parent);

            if v9 == p8 then
                u6:CleanupTool(i);
            end;
        end;
    end);
end;

function v1.PreparePartForTool(p10, p11) -- Line: 50
    p11.Anchored = false;
    p11.CanCollide = false;
    p11.CanQuery = false;
    p11.CanTouch = false;
    p11.Massless = true;
end;

function v1.ClearModel(p12, p13) -- Line: 58
    for _, child in p13:GetChildren() do
        if child:GetAttribute("ClientHandle") then
            child.Parent = nil;
            task.defer(function() -- Line: 64
                -- upvalues: child (copy)
                if child then
                    child:Destroy();
                end;
            end);
        end;
    end;
end;

function v1.HasModel(p14, p15) -- Line: 72
    for _, child in p15:GetChildren() do
        if child:GetAttribute("ClientHandle") then
            return true;
        end;
    end;

    return false;
end;

function v1.WeldToHandle(p16, p17, p18) -- Line: 81
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = p18;
    WeldConstraint.Part1 = p17;
    WeldConstraint.Parent = p17;
end;

function v1.SpawnHandle(p19, p20, p21) -- Line: 88
    -- upvalues: u4 (copy), Assets (copy)
    if u4[p20] then
        return;
    end;

    u4[p20] = true;
    p19:ClearModel(p20);
    local v22 = p20:GetAttribute("PetTeleporter");

    if not v22 then
        u4[p20] = nil;

        return;
    end;

    local PetTeleporters = Assets:FindFirstChild("PetTeleporters");

    if not PetTeleporters then
        warn("[PetTeleporterHandle] ReplicatedStorage.Assets.PetTeleporters not found (not replicated to the client?)");
        u4[p20] = nil;

        return;
    end;

    local v23 = PetTeleporters:FindFirstChild(v22);

    if not v23 then
        warn((`[PetTeleporterHandle] no model named "{v22}" under Assets.PetTeleporters`));
        u4[p20] = nil;

        return;
    end;

    local Handle = p20:FindFirstChild("Handle");

    if not (Handle and Handle:IsA("BasePart")) then
        warn((`[PetTeleporterHandle] tool "{p20.Name}" has no Handle BasePart to attach to`));
        u4[p20] = nil;

        return;
    end;

    local v24 = v23:Clone();

    if v24:IsA("BasePart") then
        if v24.Name == "Handle" then
            v24.Name = tostring(v22);
        end;

        p19:PreparePartForTool(v24);
        v24:SetAttribute("ClientHandle", true);
        v24.CFrame = Handle.CFrame;
        v24.Parent = p20;
        p19:WeldToHandle(v24, Handle);
    else
        if not v24:IsA("Model") then
            v24:Destroy();
            u4[p20] = nil;

            return;
        end;

        for _, descendant in v24:GetDescendants() do
            if descendant:IsA("BasePart") then
                p19:PreparePartForTool(descendant);
            end;
        end;

        v24:PivotTo(Handle.CFrame);
        v24:SetAttribute("ClientHandle", true);
        v24.Parent = p20;

        for _, descendant in v24:GetDescendants() do
            if descendant:IsA("BasePart") then
                p19:WeldToHandle(descendant, Handle);
            end;
        end;
    end;

    u4[p20] = nil;
end;

function v1.UpdateToolState(p25, p26) -- Line: 164
    -- upvalues: u4 (copy), u3 (copy)
    if u4[p26] then
        return;
    end;

    local v27 = u3[p26];

    if not v27 then
        return;
    end;

    local v28 = p26.Parent == v27;
    local v29 = p25:HasModel(p26);

    if v28 and not v29 then
        p25:SpawnHandle(p26, v27);

        return;
    end;

    if not v28 and v29 then
        p25:ClearModel(p26);
    end;
end;

function v1.DisconnectTool(p30, p31) -- Line: 180
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local v32 = u2[p31];

    if v32 then
        for _, v in v32 do
            v:Disconnect();
        end;

        u2[p31] = nil;
    end;

    u3[p31] = nil;
    u4[p31] = nil;
end;

function v1.CleanupTool(p33, p34) -- Line: 192
    p33:ClearModel(p34);
    p33:DisconnectTool(p34);
end;

function v1.IsTrackedTool(p35, p36) -- Line: 197
    return p36:GetAttribute("PetTeleporter") ~= nil;
end;

function v1.SetupTool(u37, u38, p39) -- Line: 201
    -- upvalues: u3 (copy), u2 (copy)
    u37:DisconnectTool(u38);
    local v40 = {};
    u3[u38] = p39;
    local v41 = u38:GetPropertyChangedSignal("Parent");
    table.insert(v40, v41:Connect(function() -- Line: 207
        -- upvalues: u38 (copy), u3 (ref), u37 (copy)
        task.defer(function() -- Line: 208
            -- upvalues: u38 (ref), u3 (ref), u37 (ref)
            if u38 and u3[u38] then
                u37:UpdateToolState(u38);
            end;
        end);
    end));
    u2[u38] = v40;
    task.defer(function() -- Line: 217
        -- upvalues: u38 (copy), u3 (ref), u37 (copy)
        if u38 and u3[u38] then
            u37:UpdateToolState(u38);
        end;
    end);
end;

function v1.SetupCharacter(u42, u43) -- Line: 224
    -- upvalues: Players (copy)
    task.defer(function() -- Line: 225
        -- upvalues: u43 (copy), u42 (copy), Players (ref)
        if not (u43 and u43.Parent) then
            return;
        end;

        for _, child in u43:GetChildren() do
            if child:IsA("Tool") and u42:IsTrackedTool(child) then
                u42:SetupTool(child, u43);
            end;
        end;

        local v44 = Players:GetPlayerFromCharacter(u43);

        if v44 and v44.Backpack then
            for _, child in v44.Backpack:GetChildren() do
                if child:IsA("Tool") and u42:IsTrackedTool(child) then
                    u42:SetupTool(child, u43);
                end;
            end;
        end;

        u43.ChildAdded:Connect(function(u45) -- Line: 243
            -- upvalues: u42 (ref), u43 (ref)
            if u45:IsA("Tool") and u42:IsTrackedTool(u45) then
                task.defer(function() -- Line: 245
                    -- upvalues: u45 (copy), u43 (ref), u42 (ref)
                    if u45 and (u45.Parent and (u43 and u43.Parent)) then
                        u42:SetupTool(u45, u43);
                    end;
                end);
            end;
        end);
    end);
end;

function v1.SetupPlayer(u46, u47) -- Line: 255
    -- upvalues: BackpackListener (copy)
    if u47.Character then
        u46:SetupCharacter(u47.Character);
    end;

    u47.CharacterAdded:Connect(function(p48) -- Line: 260
        -- upvalues: u46 (copy)
        u46:SetupCharacter(p48);
    end);
    BackpackListener.bind(u47, function(u49) -- Line: 264
        -- upvalues: u46 (copy), u47 (copy)
        if u49:IsA("Tool") and u46:IsTrackedTool(u49) then
            task.defer(function() -- Line: 266
                -- upvalues: u47 (ref), u49 (copy), u46 (ref)
                local Character = u47.Character;

                if u49 and (u49.Parent and (Character and Character.Parent)) then
                    u46:SetupTool(u49, Character);
                end;
            end);
        end;
    end);
end;

return v1;