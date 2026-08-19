-- Decompiled with Potassium's decompiler.

local Knit = require(game.ReplicatedStorage.Packages.Knit);
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UI_Manager = require(game.ReplicatedStorage.Client.Controllers.UI_Manager);
local u1 = Knit.CreateController({
    Name = "FurnitureGiveController"
});
local PlayerGui = game.Players.LocalPlayer.PlayerGui;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = false;

local function setupViewport(p9, p10) -- Line: 21
    for _, child in p9:GetChildren() do
        if child:IsA("Model") or child:IsA("Camera") then
            child:Destroy();
        end;
    end;

    local v11 = p10:Clone();

    for _, descendant in v11:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
        end;

        if descendant:IsA("Script") or descendant:IsA("LocalScript") then
            descendant:Destroy();
        end;
    end;

    v11.Parent = p9;
    local Camera = Instance.new("Camera");
    Camera.Parent = p9;
    p9.CurrentCamera = Camera;
    local v12, v13 = v11:GetBoundingBox();
    local v14 = v13.Magnitude / 2;
    local v15 = math.rad(Camera.FieldOfView / 2);
    local v16 = v14 / math.tan(v15) + v14;
    Camera.CFrame = CFrame.lookAt(v12.Position + (Vector3.new(1, 0.55, 1)).Unit * v16, v12.Position);
end;

local function selectCategory(p17) -- Line: 46
    -- upvalues: u6 (ref), u7 (ref), setupViewport (copy), UI_Manager (copy), u1 (copy)
    for _, child in u6:GetChildren() do
        if child:IsA("Frame") and child.Name == "Row" then
            child:Destroy();
        end;
    end;

    local v18 = {};

    if typeof(p17) == "Instance" then
        for _, child in p17:GetChildren() do
            if child:IsA("Model") then
                table.insert(v18, child);
            end;
        end;
    else
        v18 = p17.models;
    end;

    local u19 = typeof(p17) == "Instance" and p17.Name or p17.name;

    for i, v in v18 do
        local v20 = u7:Clone();
        v20.Name = "Row";
        v20.LayoutOrder = i;
        local TextLabel = v20:FindFirstChild("TextLabel");

        if TextLabel then
            TextLabel.Text = v.Name;
        end;

        local ViewportFrame = v20:FindFirstChild("ViewportFrame");

        if ViewportFrame then
            setupViewport(ViewportFrame, v);
        end;

        local BuyButton = v20:FindFirstChild("BuyButton");

        if BuyButton then
            BuyButton = BuyButton:FindFirstChild("Button");
        end;

        if BuyButton then
            UI_Manager:AddBounceButton(BuyButton, 1.1);
            BuyButton.Activated:Connect(function() -- Line: 76
                -- upvalues: u1 (ref), u19 (copy), v (copy)
                u1.AdminHandler.adminRemote:Fire({
                    name = "GiveDecor",
                    furnitureType = u19,
                    furnitureId = v.Name
                });
            end);
        end;

        v20.Visible = true;
        v20.Parent = u6;
    end;
end;

local function populate() -- Line: 90
    -- upvalues: u8 (ref), ReplicatedStorage (copy), u5 (ref), UI_Manager (copy), selectCategory (copy), u4 (ref)
    if u8 then
        return;
    end;

    u8 = true;
    local v21 = nil;
    local v22 = {};

    for _, child in ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Greedy"):WaitForChild("Decor"):GetChildren() do
        if child:IsA("Folder") then
            local v23 = u5:Clone();
            v23.Name = "Cat_" .. child.Name;
            local Button = v23:FindFirstChild("Button");
            local v24;

            if Button then
                v24 = Button:FindFirstChild("Identifier");
            else
                v24 = Button;
            end;

            if v24 then
                v24.Text = child.Name;
            end;

            if Button then
                UI_Manager:AddBounceButton(Button, 1.1);
                Button.Activated:Connect(function() -- Line: 107
                    -- upvalues: selectCategory (ref), child (copy)
                    selectCategory(child);
                end);
            end;

            v23.Visible = true;
            v23.Parent = u4;
            v21 = v21 or child;
        elseif child:IsA("Model") then
            table.insert(v22, child);
        end;
    end;

    if #v22 > 0 then
        local u25 = {
            name = "Misc",
            models = v22
        };
        local v26 = u5:Clone();
        v26.Name = "Cat_Misc";
        local Button = v26:FindFirstChild("Button");
        local v27;

        if Button then
            v27 = Button:FindFirstChild("Identifier");
        else
            v27 = Button;
        end;

        if v27 then
            v27.Text = "Misc";
        end;

        if Button then
            UI_Manager:AddBounceButton(Button, 1.1);
            Button.Activated:Connect(function() -- Line: 128
                -- upvalues: selectCategory (ref), u25 (copy)
                selectCategory(u25);
            end);
        end;

        v26.Visible = true;
        v26.Parent = u4;
        v21 = v21 or u25;
    end;

    if v21 then
        selectCategory(v21);
    end;
end;

function u1.Open(p28) -- Line: 140
    -- upvalues: populate (copy), UI_Manager (copy), u2 (ref)
    populate();
    UI_Manager:OpenWindow(u2, true);
end;

function u1.KnitStart(p29) -- Line: 145
    -- upvalues: PlayerGui (copy), u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), UI_Manager (copy)
    u2 = PlayerGui:WaitForChild("Windows"):WaitForChild("FurnitureGive");
    u3 = u2:WaitForChild("Top"):WaitForChild("Exit");
    u4 = u2.LeftSide.ScrollingFrame:WaitForChild("ItemHolder");
    u5 = u4:WaitForChild("Button");
    u5.Parent = script;
    u6 = u2.RightSide.ScrollingFrame:WaitForChild("ItemHolder");
    u7 = u6:WaitForChild("Row");
    u7.Parent = script;
    UI_Manager:AddBounceButton(u3, 1.2, true);
    u3.Activated:Connect(function() -- Line: 159
        -- upvalues: UI_Manager (ref), u2 (ref)
        UI_Manager:CloseWindow(u2, true);
    end);
end;

function u1.KnitInit(p30) -- Line: 164
    -- upvalues: Knit (copy)
    p30.AdminHandler = Knit.GetService("AdminHandler");
end;

return u1;