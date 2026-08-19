-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local SoundService = game:GetService("SoundService");
local TweenService = game:GetService("TweenService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local u1 = { {
        key = "DefaultFence",
        model = "WoodFence",
        line1 = "Wood Fence",
        line2 = ""
    }, {
        key = "WhiteFarmFence",
        model = "WhiteFarmFence",
        line1 = "White Farm",
        line2 = "Fence"
    }, {
        key = "StoneFence",
        model = "StoneFence",
        line1 = "Stone Fence",
        line2 = ""
    }, {
        key = "BrickFence",
        model = "BrickFence",
        line1 = "Brick Fence",
        line2 = ""
    }, {
        key = "OvergrownStoneFence",
        model = "OvergrownStoneFence",
        line1 = "Overgrown Stone",
        line2 = "Fence"
    } };
local u2 = Color3.fromHex("4cce3f");
local u3 = TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
local u4 = TweenInfo.new(0.1, Enum.EasingStyle.Circular, Enum.EasingDirection.Out, 0, true);
local u5 = Knit.CreateController({
    Name = "CustomizeFenceController"
});

function u5.KnitStart(u6) -- Line: 34
    -- upvalues: Players (copy), Knit (copy), ReplicatedStorage (copy), SoundService (copy), TweenService (copy), u3 (copy), u4 (copy), u1 (copy), u2 (copy), u5 (copy)
    local LocalPlayer = Players.LocalPlayer;
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local UI_Manager = u6.UI_Manager;
    local DataClient = u6.DataClient;
    local u7 = Knit.GetService("PlayerPlotService");
    local CustomizeFence = PlayerGui:WaitForChild("Windows"):WaitForChild("CustomizeFence");
    CustomizeFence.Visible = false;
    local Exit = CustomizeFence:WaitForChild("Top"):WaitForChild("Exit");

    local function fenceAssets() -- Line: 47
        -- upvalues: ReplicatedStorage (ref)
        local Assets = ReplicatedStorage:FindFirstChild("Assets");

        if Assets then
            Assets = Assets:FindFirstChild("Greedy");
        end;

        if Assets then
            Assets = Assets:FindFirstChild("CustomFences");
        end;

        return Assets;
    end;

    local function renderFenceViewport(p8, p9) -- Line: 53
        -- upvalues: ReplicatedStorage (ref)
        for _, child in p8:GetChildren() do
            if child:IsA("Model") or child:IsA("Camera") then
                child:Destroy();
            end;
        end;

        local ImageLabel = p8.Parent:FindFirstChild("ImageLabel");

        if ImageLabel then
            ImageLabel.Visible = false;
        end;

        p8.ZIndex = 3;
        local Assets = ReplicatedStorage:FindFirstChild("Assets");

        if Assets then
            Assets = Assets:FindFirstChild("Greedy");
        end;

        if Assets then
            Assets = Assets:FindFirstChild("CustomFences");
        end;

        if Assets then
            Assets = Assets:FindFirstChild(p9);
        end;

        if not Assets then
            return;
        end;

        local v10 = Assets:Clone();

        for _, descendant in v10:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true;
            end;
        end;

        local v11, v12 = v10:GetBoundingBox();
        v10:PivotTo(v10:GetPivot() + (Vector3.new(0, 0, 0) - v11.Position));
        v10.Parent = p8;
        local Camera = Instance.new("Camera");
        Camera.FieldOfView = 40;
        local AbsoluteSize = p8.AbsoluteSize;
        local v13 = AbsoluteSize.X > 0 and (AbsoluteSize.Y > 0 and AbsoluteSize.X / AbsoluteSize.Y) or 1.4;
        local v14 = math.rad(Camera.FieldOfView / 2);
        local v15 = math.tan(v14);
        local v16 = math.max(v12.X / 2 / (v15 * v13), v12.Y / 2 / v15) * 1.15 + v12.Z / 2;
        Camera.CFrame = CFrame.lookAt(Vector3.new(0, v12.Y * 0.15 + v16 * 0.12, v16), Vector3.new(0, 0, 0));
        Camera.Parent = p8;
        p8.CurrentCamera = Camera;
        p8.Ambient = Color3.fromRGB(200, 200, 200);
        p8.LightColor = Color3.fromRGB(255, 255, 255);
    end;

    local u17 = {};

    for _, child in CustomizeFence:WaitForChild("Content"):WaitForChild("FenceList"):WaitForChild("ScrollingFrame"):WaitForChild("ItemHolder"):GetChildren() do
        if child.Name == "Cell" then
            table.insert(u17, child);
        end;
    end;

    table.sort(u17, function(p18, p19) -- Line: 94
        return p18.LayoutOrder < p19.LayoutOrder;
    end);
    local u20 = nil;
    local u21 = nil;

    local function selectedFenceKey() -- Line: 101
        -- upvalues: DataClient (copy), u21 (ref)
        local currentData = DataClient.currentData;

        return u21 or currentData and currentData.SelectedFence or "DefaultFence";
    end;

    local SoundEffects = SoundService:FindFirstChild("SoundEffects");

    if SoundEffects then
        SoundEffects = SoundEffects:FindFirstChild("UI");
    end;

    local u22;

    if SoundEffects then
        u22 = SoundEffects:FindFirstChild("Hover");
    else
        u22 = SoundEffects;
    end;

    if SoundEffects then
        SoundEffects = SoundEffects:FindFirstChild("On");
    end;

    local function addCellFeedback(u23, p24) -- Line: 111
        -- upvalues: TweenService (ref), u3 (ref), u22 (copy), u6 (copy), LocalPlayer (copy), u4 (ref), SoundEffects (copy)
        local UIScale = Instance.new("UIScale");
        UIScale.Parent = u23;
        u23.AnchorPoint = Vector2.new(0.5, 0.5);
        local ZIndex = u23.ZIndex;
        local u25 = nil;

        local function scaleTo(p26, p27) -- Line: 117
            -- upvalues: u25 (ref), TweenService (ref), UIScale (copy), u3 (ref)
            if u25 then
                u25:Cancel();
            end;

            u25 = TweenService:Create(UIScale, p27 or u3, {
                Scale = p26
            });
            u25:Play();
        end;

        u23.MouseEnter:Connect(function() -- Line: 122
            -- upvalues: u23 (copy), ZIndex (copy), u25 (ref), TweenService (ref), UIScale (copy), u3 (ref), u22 (ref), u6 (ref), LocalPlayer (ref)
            u23.ZIndex = ZIndex + 1;

            if u25 then
                u25:Cancel();
            end;

            u25 = TweenService:Create(UIScale, u3, {
                Scale = 1.05
            });
            u25:Play();

            if u22 then
                u6.SoundController:PlaySound(u22, LocalPlayer, {
                    PlaybackSpeed = NumberRange.new(0.8, 1.2)
                });
            end;
        end);
        u23.MouseLeave:Connect(function() -- Line: 129
            -- upvalues: u23 (copy), ZIndex (copy), u25 (ref), TweenService (ref), UIScale (copy), u3 (ref)
            u23.ZIndex = ZIndex;

            if u25 then
                u25:Cancel();
            end;

            u25 = TweenService:Create(UIScale, u3, {
                Scale = 1
            });
            u25:Play();
        end);
        p24.MouseButton1Down:Connect(function() -- Line: 133
            -- upvalues: u4 (ref), u25 (ref), TweenService (ref), UIScale (copy), u3 (ref), SoundEffects (ref), u6 (ref), LocalPlayer (ref)
            if u25 then
                u25:Cancel();
            end;

            u25 = TweenService:Create(UIScale, u4 or u3, {
                Scale = 1.0185
            });
            u25:Play();

            if SoundEffects then
                u6.SoundController:PlaySound(SoundEffects, LocalPlayer);
            end;
        end);
    end;

    local function refreshSelection() -- Line: 141
        -- upvalues: DataClient (copy), u21 (ref), u1 (ref), u17 (copy), u20 (ref), u2 (ref)
        local currentData = DataClient.currentData;
        local v28 = u21 or currentData and currentData.SelectedFence or "DefaultFence";

        for i, v in u1 do
            local v29 = u17[i];

            if v29 then
                if u20 == nil then
                    u20 = v29.BackgroundColor3;
                end;

                v29.BackgroundColor3 = v.key == v28 and u2 or u20;
            end;
        end;
    end;

    local u30 = false;

    local function populate() -- Line: 153
        -- upvalues: u1 (ref), u17 (copy), renderFenceViewport (copy), addCellFeedback (copy), u7 (copy), u21 (ref), refreshSelection (copy)
        for i, v in u1 do
            local v31 = u17[i];

            if not v31 then
                break;
            end;

            local Button = v31:FindFirstChild("Button");
            local v32;

            if Button then
                v32 = Button:FindFirstChild("Furniture");
            else
                v32 = Button;
            end;

            if v32 then
                v32 = v32:FindFirstChild("ViewportFrame");
            end;

            if v32 then
                renderFenceViewport(v32, v.model);
            end;

            local v33;

            if Button then
                v33 = Button:FindFirstChild("Line1");
            else
                v33 = Button;
            end;

            local v34;

            if Button then
                v34 = Button:FindFirstChild("Line2");
            else
                v34 = Button;
            end;

            if v33 then
                v33.Text = v.line1;
            end;

            if v34 then
                v34.Text = v.line2;
            end;

            for _, v2 in { "NO STOCK", "Stock" } do
                local v35;

                if Button then
                    v35 = Button:FindFirstChild(v2);
                else
                    v35 = Button;
                end;

                if v35 then
                    v35.Visible = false;
                end;
            end;

            if Button and not v31:GetAttribute("FenceWired") then
                v31:SetAttribute("FenceWired", true);
                addCellFeedback(v31, Button);
                Button.Activated:Connect(function() -- Line: 175
                    -- upvalues: u7 (ref), v (copy), u21 (ref), refreshSelection (ref)
                    u7:SetSelectedFence(v.key):andThen(function(p36) -- Line: 176
                        -- upvalues: u21 (ref), v (ref), refreshSelection (ref)
                        if p36 then
                            u21 = v.key;
                            refreshSelection();
                        end;
                    end);
                end);
            end;
        end;

        for i = #u1 + 1, #u17 do
            u17[i].Visible = false;
        end;

        refreshSelection();
    end;

    function u5.Open(p37) -- Line: 192
        -- upvalues: u30 (ref), populate (copy), refreshSelection (copy), UI_Manager (copy), CustomizeFence (copy), DataClient (copy), u7 (copy)
        if u30 then
            refreshSelection();
        else
            u30 = true;
            populate();
        end;

        UI_Manager:OpenWindow(CustomizeFence, true);
        local currentData = DataClient.currentData;

        if currentData and not currentData.OpenedCustomizeFence then
            u7:MarkFenceOpened();
        end;
    end;

    UI_Manager:AddBounceButton(Exit, 1.2, true);
    Exit.Activated:Connect(function() -- Line: 208
        -- upvalues: UI_Manager (copy), CustomizeFence (copy)
        UI_Manager:CloseWindow(CustomizeFence, true);
    end);
end;

function u5.KnitInit(p38) -- Line: 213
    -- upvalues: Knit (copy)
    p38.UI_Manager = Knit.GetController("UI_Manager");
    p38.DataClient = Knit.GetController("DataClient");
    p38.SoundController = Knit.GetController("SoundController");
end;

return u5;