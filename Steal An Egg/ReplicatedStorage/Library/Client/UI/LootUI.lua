-- Decompiled with Potassium's decompiler.

local u1 = {
    ARROW_DIRECTION = {
        Down = 1,
        Left = 2,
        Right = 3
    }
};
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local InfoOverlay = require(ReplicatedStorage:WaitForChild("Library").Client.InfoOverlay);
local Rainbow = require(ReplicatedStorage:WaitForChild("Library").Client.GUIFX.Rainbow);
local DropTable = require(ReplicatedStorage:WaitForChild("Library").DropTable);
local Functions = require(ReplicatedStorage:WaitForChild("Library").Functions);
local ItemUI = require(ReplicatedStorage:WaitForChild("Library").Client.UI.ItemUI);
local DropInfo = ReplicatedStorage.Assets.UI.DropTable.DropInfo;
local Render = ReplicatedStorage.Assets.UI.DropTable.Render;
local u2 = {
    Comparator = nil,
    Distance = 20,
    Scale = 1,
    PageTurnLength = 5,
    ShowRolls = true,
    ShowPageNumbers = true,
    Title = "Display!",
    HeightOffset = 5,
    SurgeNumber = nil,
    ArrowDirection = u1.ARROW_DIRECTION.Down
};
local u3 = {};
local u4 = tick();

local function RenderPage(u5, p6, p7) -- Line: 83
    -- upvalues: Functions (copy), RunService (copy), Render (copy), Rainbow (copy), ItemUI (copy)
    local Billboard = u5.Billboard;
    assert(Billboard, "Billboard not found");
    local Container = Billboard.Frame.Items.Container;

    local function clearContainer() -- Line: 88
        -- upvalues: Container (copy)
        for _, child in ipairs(Container:GetChildren()) do
            if child:IsA("GuiObject") then
                child:Destroy();
            end;
        end;
    end;

    if not p7 then
        u5.TweeningPage = true;
        Functions.Tween(Container, {
            Position = UDim2.new(-1, 0, 0, 0)
        }, { 0.125, "Quad", "Out" }).Completed:Connect(function() -- Line: 99
            -- upvalues: u5 (copy)
            u5.TweeningPage = false;
        end);

        while u5.TweeningPage do
            RunService.RenderStepped:Wait();
        end;

        if not u5.Billboard then
            return;
        end;
    end;

    clearContainer();
    local v8 = {};

    for i = (p6 - 1) * 9 + 1, math.min(p6 * 9, #u5.DropProbability) do
        table.insert(v8, u5.DropProbability[i]);
    end;

    for i, v in ipairs(v8) do
        local ItemBase = v.ItemBase;
        local v9 = v.Probability * 100;
        local MinAmount = v.MinAmount;
        local MaxAmount = v.MaxAmount;
        local v10;

        if MinAmount == MaxAmount then
            v10 = Functions.NumberShorten(MinAmount);
        elseif MinAmount < 1 then
            v10 = `{Functions.NumberShorten(MaxAmount)}`;
        else
            v10 = `{Functions.NumberShorten(MinAmount)} - {Functions.NumberShorten(MaxAmount)}`;
        end;

        local v11 = Render:Clone();
        v11.Holder:ClearAllChildren();
        v11.LayoutOrder = i;

        if v9 < 0.1 then
            v11.Chance.Text = "??";
            Rainbow(v11.Chance, "TextColor3");
        else
            local v12 = math.pow(0.9315, v9) * 94.2467 / 100;
            local v13 = math.clamp(v12, 0, 1);
            local v14, v15, v16 = Color3.fromRGB(49, 255, 39):Lerp(Color3.fromRGB(255, 75, 39), v13):ToHSV();
            local v17 = Color3.fromHSV(v14, v15, v16 * 2);
            v11.Chance.TextColor3 = v17;
            v11.Chance.Text = `{Functions.FormatFigures(v9, 3, 5)}%`;
        end;

        local v18 = ItemUI.Create(ItemBase, {
            NoActionMenu = true,
            NoButtonFX = true,
            HideQuantity = true,
            ShowCurrencyBag = true,
            HideLevel = true,
            QuantityOverride = math.round(v.AvgAmount)
        });
        v18.Selectable = false;
        v18:SetAttribute("SurfaceElement", true);
        v18.Strength.Size = Functions.ScaleUDim2(v18.Strength.Size, 0.6666666666666666);
        local UIStroke = v18.Strength.UIStroke;
        UIStroke.Thickness = UIStroke.Thickness * 0.6666666666666666;
        v18.Strength.Text = v10;
        v18.Strength.Visible = v10 ~= "1";
        v18.Parent = v11.Holder;
        v11.Parent = Container;
    end;

    local Rolls = u5.Rolls;
    local v19;

    if u5.Config.SurgeNumber then
        Rolls = Rolls * u5.Config.SurgeNumber;
        v19 = "SURGE: ";
    else
        v19 = "";
    end;

    local v20 = `{v19}{Rolls} Rolls!`;
    Billboard.Frame.Rolls.Text = v20;
    Billboard.Frame.PageNumber.Text = `{p6}/{u5.NumberOfPages}`;
    u5.PageNumber = p6;

    if p7 then
        Container.Position = UDim2.new();

        return;
    end;

    Container.Position = UDim2.new(1, 0, 0, 0);
    u5.TweeningPage = true;
    Functions.Tween(Container, {
        Position = UDim2.new(0, 0, 0, 0)
    }, { 0.125, "Quad", "Out" }).Completed:Connect(function() -- Line: 196
        -- upvalues: u5 (copy)
        u5.TweeningPage = false;
    end);
end;

function u1.Add(p21, p22, p23) -- Line: 202
    -- upvalues: u2 (copy), Functions (copy), DropTable (copy), u3 (copy)
    assert(p21, "host must be provided");
    assert(p22, "dropTable must be provided");
    local u24 = p23 or {};

    for i, v in pairs(u2) do
        if u24[i] == nil then
            u24[i] = v;
        end;
    end;

    assert(u24.Distance, "config.Distance is required");
    assert(u24.ShowRolls ~= nil, "config.ShowRolls must be defined");
    assert(u24.ShowPageNumbers ~= nil, "config.ShowPageNumbers must be defined");
    assert(u24.Title, "config.Title is required");
    assert(u24.Comparator, "config.Comparator is required");
    local u25 = nil;
    local u26 = false;

    if typeof(p21) == "Instance" then
        if p21:IsA("Model") then
            u25 = p21.PrimaryPart;
            assert(u25, "Provided Model must have a PrimaryPart");
        elseif p21:IsA("BasePart") then
            u25 = p21;
        else
            error("Unknown host type: " .. typeof(p21));
        end;
    else
        local v27 = typeof(p21) == "Vector3" and true or typeof(p21) == "CFrame";
        assert(v27, "host must be an Instance, Vector3, or CFrame");
        u25 = Functions.CreateParticleHost(p21);
        u26 = true;
    end;

    local u28 = Functions.GenerateUID();
    local u29 = false;
    local v30, v31;

    if #p22.entries == 1 then
        local v32 = p22.entries[1];
        v30 = v32.Amount or 1;
        v31 = DropTable.new({
            {
                Weight = 1,
                Value = v32.Value
            }
        });
    else
        v31 = p22;
        v30 = 1;
    end;

    local v33 = v31:GetDisplayTable();
    local v34 = table.clone(v33);
    table.sort(v34, function(p35, p36) -- Line: 256
        -- upvalues: u24 (copy)
        return u24.Comparator(p35.ItemBase, p35.Probability, p36.ItemBase, p36.Probability);
    end);
    u3[u28] = {
        PageNumber = 1,
        Config = u24,
        NumberOfPages = math.ceil(#v34 / 9),
        LastPageTurn = tick(),
        UID = u28,
        Billboard = nil,
        Showing = false,
        Tweening = false,
        TweeningPage = false,
        Host = u25,
        DropProbability = v34,
        OriginalDropTable = p22,
        Rolls = v30,
        DropTable = v31
    };
    local u37 = u3[u28];

    local function cleanup() -- Line: 282
        -- upvalues: u29 (ref), u37 (copy), u26 (ref), u25 (ref), u3 (ref), u28 (copy)
        if not u29 then
            u29 = true;

            if u37.Billboard then
                u37.Billboard:Destroy();
            end;

            if u26 then
                u25:Destroy();
            end;

            u3[u28] = nil;
        end;
    end;

    if typeof(p21) == "Instance" then
        p21.Destroying:Connect(cleanup);
    end;

    return cleanup;
end;

u1.Comparators = {
    RaritySorted = function(p38, p39, p40, p41) -- Line: 301, Name: RaritySorted
        local v42 = p38:GetRarity();
        local v43 = p40:GetRarity();

        if v42 == v43 then
            return p41 < p39;
        end;

        return v42.RarityNumber < v43.RarityNumber;
    end,

    ReverseRaritySorted = function(p44, p45, p46, p47) -- Line: 316, Name: ReverseRaritySorted
        local v48 = p44:GetRarity();
        local v49 = p46:GetRarity();

        if v48 == v49 then
            return p45 < p47;
        end;

        return v48.RarityNumber > v49.RarityNumber;
    end,

    PercentSorted = function(p50, p51, p52, p53) -- Line: 331, Name: PercentSorted
        return p53 < p51;
    end,

    ClassSorted = function(p54, p55, p56, p57) -- Line: 334, Name: ClassSorted
        -- upvalues: u1 (copy)
        local Name = p54.Class.Name;
        local Name2 = p56.Class.Name;
        p54:GetRarity();
        p56:GetRarity();

        if Name == Name2 then
            return u1.Comparators.RaritySorted(p54, p55, p56, p57);
        end;

        return Name < Name2;
    end
};
u2.Comparator = u1.Comparators.RaritySorted;

local function UpdateArrowVisibility(p58, p59) -- Line: 348
    -- upvalues: u1 (copy)
    local v60 = {
        Left = p58.Frame.Pointer_Left,
        Right = p58.Frame.Pointer_Right,
        Down = p58.Frame.Pointer_Down
    };
    local v61 = p59 == u1.ARROW_DIRECTION.Left and v60.Left or (p59 == u1.ARROW_DIRECTION.Right and v60.Right or v60.Down);

    for _, v in pairs(v60) do
        v.Visible = v == v61;
    end;
end;

RunService.RenderStepped:Connect(function() -- Line: 364
    -- upvalues: InfoOverlay (copy), u4 (ref), u3 (copy), Functions (copy), DropInfo (copy), UpdateArrowVisibility (copy), RenderPage (copy)
    local Character = game.Players.LocalPlayer.Character;

    if Character then
        if InfoOverlay.IsActive() then
            u4 = tick();
        end;

        local Position = Character:GetPivot().Position;

        for _, v in pairs(u3) do
            if not (v.Tweening or v.TweeningPage) then
                local Magnitude = (Position - v.Host.Position).Magnitude;
                local Distance = v.Config.Distance;
                local v62 = Distance + 4;

                if v.Billboard or Distance <= Magnitude then
                    if v.Billboard and v62 < Magnitude then
                        v.Tweening = true;
                        Functions.Tween(v.Billboard, {
                            Size = UDim2.new()
                        }, { 0.15, "Expo", "Out" }).Completed:Connect(function() -- Line: 381
                            -- upvalues: v (copy)
                            v.Billboard:Destroy();
                            v.Billboard = nil;
                            v.Tweening = false;
                        end);
                    end;
                else
                    v.Tweening = true;
                    local v63 = DropInfo:Clone();
                    UpdateArrowVisibility(v63, v.Config.ArrowDirection);
                    local v64 = UDim2.new(v63.Size.X.Scale * v.Config.Scale, v63.Size.X.Offset, v63.Size.Y.Scale * v.Config.Scale, v63.Size.Y.Scale);
                    v63.Adornee = v.Host;
                    v63.StudsOffset = Vector3.new(0, v.Config.HeightOffset, 0);
                    v63.Size = UDim2.new();
                    v63.Frame.Title.Text = v.Config.Title;
                    v63.Frame.Rolls.Visible = v.Config.ShowRolls and v.Rolls > 1;
                    v63.Frame.PageNumber.Visible = v.Config.ShowPageNumbers and v.NumberOfPages > 1;
                    v63.Parent = game.Players.LocalPlayer.PlayerGui;
                    v.Billboard = v63;
                    v.LastPageTurn = tick();
                    task.spawn(RenderPage, v, 1, true);
                    Functions.Tween(v63, {
                        Size = v64
                    }, { 0.15, "Back", "Out" }).Completed:Connect(function() -- Line: 416
                        -- upvalues: v (copy)
                        v.Tweening = false;
                    end);
                end;

                local v65;

                if tick() - v.LastPageTurn > v.Config.PageTurnLength and tick() - u4 > 0.5 then
                    v65 = v.Billboard and not v.Tweening and not v.TweeningPage;
                else
                    v65 = false;
                end;

                if v65 and v.NumberOfPages > 1 then
                    task.spawn(RenderPage, v, v.PageNumber >= v.NumberOfPages and 1 or v.PageNumber + 1);
                    v.LastPageTurn = tick();
                end;
            end;
        end;
    end;
end);

return u1;