-- Decompiled with Potassium's decompiler.

local v1 = {};
local LocalPlayer = game:GetService("Players").LocalPlayer;
local NotificationController = require(LocalPlayer.PlayerScripts.Controllers.NotificationController);

local function HasFriendInServer() -- Line: 13
    -- upvalues: LocalPlayer (copy)
    local v2 = LocalPlayer:GetAttribute("Friends");
    local v3;

    if type(v2) == "number" then
        v3 = v2 > 0;
    else
        v3 = false;
    end;

    return v3;
end;

local function IsWheelbarrowTool(p4) -- Line: 18
    if p4:IsA("Tool") then
        return p4:GetAttribute("Wheelbarrow") ~= nil and true or p4.Name == "Wheelbarrow";
    end;

    return false;
end;

local function UnequipCurrentTool(p5) -- Line: 24
    local v6 = p5:FindFirstChildOfClass("Humanoid");

    if v6 then
        v6:UnequipTools();
    end;
end;

local function HandleEquipped(p7) -- Line: 31
    -- upvalues: LocalPlayer (copy), NotificationController (copy)
    local v8 = LocalPlayer:GetAttribute("Friends");
    local v9;

    if type(v8) == "number" then
        v9 = v8 > 0;
    else
        v9 = false;
    end;

    if v9 then
        return;
    end;

    local Parent = p7.Parent;

    if not (Parent and Parent:IsA("Model")) then
        return;
    end;

    local v10 = Parent:FindFirstChildOfClass("Humanoid");

    if v10 then
        v10:UnequipTools();
    end;

    NotificationController:CreateNotification("Friend in Server Required!");
end;

local function ConnectTool(u11) -- Line: 43
    -- upvalues: LocalPlayer (copy), NotificationController (copy)
    u11.Equipped:Connect(function() -- Line: 44
        -- upvalues: u11 (copy), LocalPlayer (ref), NotificationController (ref)
        local v12 = LocalPlayer:GetAttribute("Friends");
        local v13;

        if type(v12) == "number" then
            v13 = v12 > 0;
        else
            v13 = false;
        end;

        if v13 then
            return;
        end;

        local Parent = u11.Parent;

        if Parent then
            if not Parent:IsA("Model") then
                return;
            end;

            local v14 = Parent:FindFirstChildOfClass("Humanoid");

            if v14 then
                v14:UnequipTools();
            end;

            NotificationController:CreateNotification("Friend in Server Required!");
        end;
    end);
end;

local u15 = {};

local function TryConnect(u16) -- Line: 51
    -- upvalues: u15 (copy), LocalPlayer (copy), NotificationController (copy)
    local v17;

    if u16:IsA("Tool") then
        v17 = u16:GetAttribute("Wheelbarrow") ~= nil and true or u16.Name == "Wheelbarrow";
    else
        v17 = false;
    end;

    if not v17 then
        return;
    end;

    if u15[u16] then
        return;
    end;

    u15[u16] = true;
    u16.Equipped:Connect(function() -- Line: 44
        -- upvalues: u16 (copy), LocalPlayer (ref), NotificationController (ref)
        local v18 = LocalPlayer:GetAttribute("Friends");
        local v19;

        if type(v18) == "number" then
            v19 = v18 > 0;
        else
            v19 = false;
        end;

        if v19 then
            return;
        end;

        local Parent = u16.Parent;

        if Parent then
            if not Parent:IsA("Model") then
                return;
            end;

            local v20 = Parent:FindFirstChildOfClass("Humanoid");

            if v20 then
                v20:UnequipTools();
            end;

            NotificationController:CreateNotification("Friend in Server Required!");
        end;
    end);
    u16.AncestryChanged:Connect(function(p21, p22) -- Line: 57
        -- upvalues: u15 (ref), u16 (copy)
        if p22 == nil then
            u15[u16] = nil;
        end;
    end);
end;

local function WatchContainer(p23) -- Line: 64
    -- upvalues: TryConnect (copy)
    p23.ChildAdded:Connect(TryConnect);

    for _, child in p23:GetChildren() do
        TryConnect(child);
    end;
end;

function v1.Init(p24) -- Line: 71
end;

function v1.Start(p25) -- Line: 74
    -- upvalues: LocalPlayer (copy), TryConnect (copy)
    local Backpack = LocalPlayer:WaitForChild("Backpack");
    Backpack.ChildAdded:Connect(TryConnect);

    for _, child in Backpack:GetChildren() do
        TryConnect(child);
    end;

    local function onCharacter(p26) -- Line: 80
        -- upvalues: TryConnect (ref)
        p26.ChildAdded:Connect(TryConnect);

        for _, child in p26:GetChildren() do
            TryConnect(child);
        end;
    end;

    if LocalPlayer.Character then
        local Character = LocalPlayer.Character;
        Character.ChildAdded:Connect(TryConnect);

        for _, child in Character:GetChildren() do
            TryConnect(child);
        end;
    end;

    LocalPlayer.CharacterAdded:Connect(onCharacter);
end;

return v1;