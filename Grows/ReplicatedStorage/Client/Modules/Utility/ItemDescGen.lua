-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Frames = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Gui"):WaitForChild("Frames");
local Knit = require(ReplicatedStorage.Packages.Knit);
local Shared = ReplicatedStorage:WaitForChild("Shared");
local ExpandedRarities = require(Shared.Info.ExpandedRarities);
local ItemHelperFunctions = require(Shared.Utility.ItemHelperFunctions);
local Maid = require(game.ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Maid"));
local CustomEnum = require(game.ReplicatedStorage.Shared.Info.CustomEnum);
local ItemDescFrameTemplate = Frames:WaitForChild("ItemDescFrameTemplate");
local ButtonFrameTemplate = Frames:WaitForChild("ButtonFrameTemplate");
local Line1 = ItemDescFrameTemplate:WaitForChild("Desc"):WaitForChild("Line1");
Line1.Parent = script;
ButtonFrameTemplate:WaitForChild("Buttons"):WaitForChild("TextButtonHolder").Parent = script;
ButtonFrameTemplate:WaitForChild("ItemsFoundTitle").Visible = false;
local ItemsFound = ButtonFrameTemplate:WaitForChild("ItemsFound");
ItemsFound.Visible = false;
local u1 = {};

for _, child in ItemsFound:GetChildren() do
    if child:IsA("Frame") then
        child:Destroy();
    end;
end;

local ItemDescriptions = game.Players.LocalPlayer.PlayerGui:WaitForChild("Overlay", 10):WaitForChild("ItemDescriptions");
local u2 = {};
local u3 = {};
local u4 = 1;

function u1.IsButtonWindowOpen(p5) -- Line: 72
    return false;
end;

function u1.IsItemDescOpen(p6, p7) -- Line: 76
    -- upvalues: u2 (copy)
    return u2[p7] and true or false;
end;

function u1.AdjustWindowPos(p8, p9, p10, p11, p12) -- Line: 81
    -- upvalues: u3 (copy)
    if not u3[p9] then
        return;
    end;

    local ViewportSize = game.Workspace.Camera.ViewportSize;
    local v13 = UDim2.new(0, u3[p9].AbsoluteSize.X, 0, u3[p9].AbsoluteSize.Y);
    local v14 = UDim2.new(0, p10.X.Offset + p12, 0, p10.Y.Offset);

    if v14.X.Offset > ViewportSize.X - v13.X.Offset then
        u3[p9].AnchorPoint = Vector2.new(1, 0);
        v14 = UDim2.new(0, p10.X.Offset, 0, p10.Y.Offset);
    end;

    local v15 = math.clamp(v14.Y.Offset, 0, ViewportSize.Y - v13.Y.Offset);
    local v16 = UDim2.new(0, v14.X.Offset, 0, v15);
    u3[p9].Position = v16;
end;

function u1.OpenDesc(p17, p18, p19, p20, p21, p22) -- Line: 118
    -- upvalues: u1 (copy), u4 (ref), u2 (copy), Maid (copy), ItemDescFrameTemplate (copy), ItemDescriptions (copy), ExpandedRarities (copy), Line1 (copy), Knit (copy), CustomEnum (copy), TweenService (copy), u3 (copy)
    u1:QuickCloseAllDesc();
    local v23 = p22 or {};
    u4 = u4 + 1;
    u2[u4] = Maid.new();
    local u24 = ItemDescFrameTemplate:Clone();
    u24.GroupTransparency = 1;
    u24.Parent = ItemDescriptions;

    if p20 then
        u24.Top.Title.Text = p20;
    else
        u24.Top.Title.Visible = false;
    end;

    if p21 then
        local v25 = ExpandedRarities[p21.rarity];
        u24.Top.Rarity.Title.Text = v25.name;
        u24.Top.Rarity.Title.TextColor3 = v25.mainColor;
        u24.Top.Rarity.Title.UIStroke.Color = v25.subColor;
    else
        u24.Top.Rarity.Visible = false;
    end;

    local v26 = #v23;

    for i = 1, v26 do
        local v27 = Line1:Clone();
        v27.Name = "Line" .. i;
        v27.LayoutOrder = i;
        v27.Text = v23[i];
        v27.Parent = u24.Desc;
        v27.Size = UDim2.new(0.9, 0, 1 / v26, 0);
        v27.RichText = true;
    end;

    local ViewportSize = game.Workspace.Camera.ViewportSize;
    local v28;

    if Knit.GetController("UserInputParser"):getInputType() == CustomEnum.INPUT_TYPES.MOBILE then
        v28 = UDim2.new(0, ViewportSize.Y * 0.45, 0, ViewportSize.Y * 0.6);
    else
        v28 = UDim2.new(0, ViewportSize.Y * 0.25, 0, ViewportSize.Y * 0.4);
    end;

    u24.Size = v28;
    local v29 = u24.Size.Y.Offset / ItemDescFrameTemplate.Size.Y.Offset;
    local v30 = 20 * v29;
    local v31, v32;

    if p20 == nil and p21 == nil then
        u24.Top.Visible = false;
        u24.Separator.Visible = false;
        v31 = 0;
        v32 = 0;
    else
        v31 = 70 * v29;
        u24.Top.Size = UDim2.new(1, 0, 0, v31);
        u24.Separator.Size = UDim2.new(0.96, 0, 0, 5 * v29);
        local v33 = 5 * v29;
        u24.UIListLayout.Padding = UDim.new(0, v33);
        v32 = v33 * 4;
    end;

    if v26 < 1 then
        u24.Separator.Visible = false;
        v32 = 0;
    end;

    u24.UICorner.CornerRadius = UDim.new(0, 8 * v29);
    u24.Desc.Size = UDim2.new(1, 0, 0, v30 * v26);
    u24.Size = UDim2.new(0, v28.X.Offset, 0, v31 + v26 * v30 + v32);
    TweenService:Create(u24, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        GroupTransparency = 0
    }):Play();
    u3[u4] = u24;
    u1:AdjustWindowPos(u4, p18, CustomEnum.SUB_WINDOW_TYPE.DESC, p19);
    u2[u4]:GiveTask(function() -- Line: 242
        -- upvalues: u24 (copy), u2 (ref), u4 (ref), u3 (ref)
        if u24 then
            u24:Destroy();
        end;

        u2[u4] = nil;
        u3[u4] = nil;
    end);

    return u4;
end;

function u1.OpenItemDesc(p34, p35, p36, p37, p38) -- Line: 253
    -- upvalues: ItemHelperFunctions (copy), CustomEnum (copy)
    local v39 = p35[2];
    local v40 = p35[3];
    local v41 = ItemHelperFunctions:GetItemModule(p35[1]);
    local v42 = {};

    if v41.descriptionType == CustomEnum.DESC_TYPE.REGULAR then
        v42 = table.clone(v41.description);
    elseif v41.descriptionType == CustomEnum.DESC_TYPE.WEAPON then
        v42 = {};
    elseif v41.descriptionType == CustomEnum.DESC_TYPE.VALUE then
        if v41.CurrencyType == CustomEnum.CURRENCIES.SCRAP then
            v42 = { "Value: " .. v41.ScrapValue };
        else
            v42 = v41.CurrencyType == CustomEnum.CURRENCIES.FROSTED_BRAINS and { "Frosted Brains: " .. v41.ScrapValue } or v42;
        end;
    end;

    if p38 then
        for _, v in p38 do
            table.insert(v42, v);
        end;
    end;

    return p34:OpenDesc(p36, p37, v41:GetData(v39, v40).name, {
        rarity = v41.rarity
    }, v42);
end;

function u1.QuickCloseAllDesc(p43) -- Line: 289
    -- upvalues: u2 (copy)
    for _, v in u2 do
        v:Destroy();
    end;
end;

function u1.CloseDesc(p44, p45) -- Line: 295
    -- upvalues: u2 (copy)
    if u2[p45] then
        u2[p45]:Destroy();
    end;
end;

return u1;