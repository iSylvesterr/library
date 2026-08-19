-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Assets = require(ReplicatedStorage.Directory.Assets);
local AssetColorUtil = require(ReplicatedStorage.Library.Util.AssetColorUtil);
local AssetGenerationUtil = require(ReplicatedStorage.Library.Util.AssetGenerationUtil);
local AssetGenderUtil = require(ReplicatedStorage.Library.Util.AssetGenderUtil);
local AssetIconShape = require(ReplicatedStorage.Library.Client.UI.AssetIconShape);
local AssetItem = require(ReplicatedStorage.Library.Types.AssetItem);
local AssetItemUtil = require(ReplicatedStorage.Library.Util.AssetItemUtil);
local GetOrCreateUIScale = require(ReplicatedStorage.Library.Functions.GetOrCreateUIScale);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Mutations = require(ReplicatedStorage.Library.Modules.Mutations);
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local TabController = require(ReplicatedStorage.Library.Client.TabController);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Tween = require(ReplicatedStorage.Library.Functions.Tween);
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local u1 = Color3.fromRGB(48, 255, 105);
local u2 = UDim2.fromScale(0, 0.055);
local u3 = table.freeze({ -1, 1, -1, 1, -1, 0 });
local u4 = Log.new();
local u5 = Random.new();
local u6 = false;
local v7 = GUI.Get("StealDnaMessage");
local v8 = v7:IsA("ScreenGui");
assert(v8, "PlayerGui.StealDnaMessage must be a ScreenGui");
local Frame = v7.Frame;
local v9 = Frame:IsA("Frame");
assert(v9, "StealDnaMessage.Frame must be a Frame");
local Contents = Frame.Contents;
local v10 = Contents:IsA("Frame");
assert(v10, "StealDnaMessage.Frame.Contents must be a Frame");
local Desc = Contents.Desc;
local v11 = Desc:IsA("TextLabel");
assert(v11, "StealDnaMessage Contents.Desc must be a TextLabel");
local AssetIcon = Contents.AssetIcon;
local v12 = AssetIcon:IsA("ImageLabel");
assert(v12, "StealDnaMessage Contents.AssetIcon must be an ImageLabel");
local Position = AssetIcon.Position;
local Rotation = AssetIcon.Rotation;
local ColorBG = AssetIcon.ColorBG;
local v13 = ColorBG:IsA("GuiObject");
assert(v13, "StealDnaMessage AssetIcon.ColorBG must be a GuiObject");
local StealButton = Contents.StealButton;
local v14 = StealButton:IsA("GuiObject");
assert(v14, "StealDnaMessage Contents.StealButton must be a GuiObject");
local TextLabel = StealButton.TextLabel;
local v15 = TextLabel:IsA("TextLabel");
assert(v15, "StealButton.TextLabel must be a TextLabel");
local u16 = GetOrCreateUIScale(TextLabel);
local TextColor3 = TextLabel.TextColor3;
local Scale = u16.Scale;
local Stats1 = Contents.Stats1;
local v17 = Stats1:IsA("GuiObject");
assert(v17, "StealDnaMessage Contents.Stats1 must be a GuiObject");
local Text = Stats1.Rarity.Text;
local v18 = Text:IsA("TextLabel");
assert(v18, "Stats1.Rarity.Text must be a TextLabel");
local Text2 = Stats1.Weight.Text;
local v19 = Text2:IsA("TextLabel");
assert(v19, "Stats1.Weight.Text must be a TextLabel");
local Text3 = Stats1.Money.Text;
local v20 = Text3:IsA("TextLabel");
assert(v20, "Stats1.Money.Text must be a TextLabel");
local Stats2 = Contents.Stats2;
local v21 = Stats2:IsA("GuiObject");
assert(v21, "StealDnaMessage Contents.Stats2 must be a GuiObject");
local v22 = Stats2.Gender.Text:IsA("TextLabel");
assert(v22, "Stats2.Gender.Text must be a TextLabel");
local Image = Stats2.Gender.Image;
local v23 = Image:IsA("ImageLabel");
assert(v23, "Stats2.Gender.Image must be an ImageLabel");
local Text4 = Stats2.Personality.Text;
local v24 = Text4:IsA("TextLabel");
assert(v24, "Stats2.Personality.Text must be a TextLabel");
local Mutations2 = Stats2.Mutations;
local v25 = Mutations2:IsA("GuiObject");
assert(v25, "Stats2.Mutations must be a GuiObject");
local Mutations3 = Mutations2.Mutations;
local v26 = Mutations3:IsA("GuiObject");
assert(v26, "Stats2.Mutations.Mutations must be a GuiObject");
local Template = Mutations3.Template;
local v27 = Template:IsA("ImageLabel");
assert(v27, "Mutation icon Template must be an ImageLabel");
local u32 = {
    _collectMutationNames = function(p28) -- Line: 98, Name: _collectMutationNames
        local u29 = {};
        local u30 = {};

        local function include(p31) -- Line: 102
            -- upvalues: u30 (copy), u29 (copy)
            if p31 == nil or (p31 == "" or (p31 == "None" or u30[p31])) then
                return;
            end;

            u30[p31] = true;
            table.insert(u29, p31);
        end;

        local BaseMutation = p28.BaseMutation;

        if BaseMutation ~= nil and (BaseMutation ~= "" and (BaseMutation ~= "None" and not u30[BaseMutation])) then
            u30[BaseMutation] = true;
            table.insert(u29, BaseMutation);
        end;

        for _, v in ipairs(p28.Mutations) do
            if v ~= nil and (v ~= "" and v ~= "None") then
                if not u30[v] then
                    u30[v] = true;
                    table.insert(u29, v);
                end;
            end;
        end;

        return u29;
    end
};

function u32._populateMutations(p33, p34) -- Line: 119
    -- upvalues: Template (copy), u32 (copy), Mutations2 (copy), Mutations (copy), Mutations3 (copy)
    Template.Visible = false;
    local v35 = u32._collectMutationNames(p34);
    Mutations2.Visible = #v35 > 0;

    for _, v in ipairs(v35) do
        local v36 = Mutations.GetMutation(v);
        local v37 = `Unknown mutation "{v}"`;
        local Icon = assert(v36, v37).Icon;

        if Icon ~= nil and Icon ~= 0 then
            local v38 = Template:Clone();
            v38.Name = v;
            v38.Image = `rbxassetid://{Icon}`;
            v38.Visible = true;
            v38.Parent = Mutations3;
            p33:Add(v38);
        end;
    end;
end;

function u32._populate(p39, p40, p41) -- Line: 140
    -- upvalues: Assets (copy), Desc (copy), Text (copy), Text2 (copy), AssetItemUtil (copy), Simple (copy), AssetGenerationUtil (copy), Text3 (copy), AssetGenderUtil (copy), Image (copy), Text4 (copy), AssetIconShape (copy), AssetIcon (copy), AssetColorUtil (copy), ColorBG (copy), u32 (copy)
    local v42 = Assets.Directory[p40.Category];
    local v43 = `Unknown asset category "{p40.Category}"`;
    assert(v42 ~= nil, v43);
    local v44 = not p41 and "" or `{p41} `;
    Desc.RichText = true;
    Desc.Text = `You’ll get a {v44}<font color="#{v42.Rarity.Color:ToHex()}">{v42.Egg.DisplayName}</font> copy:`;
    Text.Text = v42.Rarity.DisplayName;
    Text.TextColor3 = v42.Rarity.Color;
    Text2.Text = AssetItemUtil.GetVisualWeightKgDisplay(p40):gsub("Kg$", "kg");
    Text3.Text = `${Simple.FormatCompact(AssetGenerationUtil.GetBaseRateMutationOnly(p40), "precision-integer")}`;
    local v45 = AssetGenderUtil.ResolveForCategory(p40.Category, p40.Gender);
    local v46 = `Invalid asset gender "{v45}"`;
    assert(v45 == "Male" and true or v45 == "Female", v46);
    local v47;

    if v45 == "Male" then
        v47 = AssetGenderUtil.GetIcon("Male");
    else
        v47 = AssetGenderUtil.GetIcon("Female");
    end;

    Image.Image = v47;
    Text4.Text = p40.Personality;
    AssetIconShape.Apply(AssetIcon, p40);
    local v48 = AssetColorUtil.ResolveFields(p40.Category, p40.EyeColor, p40.ColorSeed, p40.ColorIndex);
    local v49 = AssetColorUtil.ResolveModelColor(p40.Category, v48.ColorIndex);
    ColorBG.Visible = v49 ~= nil;

    if v49 ~= nil then
        ColorBG.BackgroundColor3 = v49;
    end;

    u32._populateMutations(p39, p40);
end;

function u32._startStealAnimation(u50, u51) -- Line: 175
    -- upvalues: TextLabel (copy), TextColor3 (copy), u16 (copy), Scale (copy), Tween (copy), u1 (copy)
    TextLabel.TextColor3 = TextColor3;
    u16.Scale = Scale;
    u50:Add(function() -- Line: 178
        -- upvalues: TextLabel (ref), TextColor3 (ref), u16 (ref), Scale (ref)
        TextLabel.TextColor3 = TextColor3;
        u16.Scale = Scale;
    end);
    u50:Add(task.spawn(function() -- Line: 183
        -- upvalues: u51 (copy), TextLabel (ref), TextColor3 (ref), u16 (ref), Scale (ref), Tween (ref), u1 (ref), u50 (copy)
        while u51() do
            TextLabel.TextColor3 = TextColor3;
            u16.Scale = Scale;
            local v52 = Tween(TextLabel, {
                TextColor3 = u1
            }, { 0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out });
            local v53 = Tween(u16, {
                Scale = Scale * 1.3
            }, { 0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out });
            u50:Add(v52);
            u50:Add(v53);
            v53.Completed:Wait();

            if not u51() then
                break;
            end;

            local v54 = Tween(TextLabel, {
                TextColor3 = TextColor3
            }, { 0.62, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out });
            local v55 = Tween(u16, {
                Scale = Scale
            }, { 0.62, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out });
            u50:Add(v54);
            u50:Add(v55);
            v55.Completed:Wait();
            TextLabel.TextColor3 = TextColor3;
            u16.Scale = Scale;
        end;
    end));
end;

function u32._startIconAnimation(u56, u57) -- Line: 223
    -- upvalues: AssetIcon (copy), Position (copy), Rotation (copy), u5 (copy), u2 (copy), Tween (copy), u3 (copy)
    AssetIcon.Position = Position;
    AssetIcon.Rotation = Rotation;
    u56:Add(function() -- Line: 226
        -- upvalues: AssetIcon (ref), Position (ref), Rotation (ref)
        AssetIcon.Position = Position;
        AssetIcon.Rotation = Rotation;
    end);
    u56:Add(task.spawn(function() -- Line: 231
        -- upvalues: u57 (copy), AssetIcon (ref), Position (ref), Rotation (ref), u5 (ref), u2 (ref), Tween (ref), u56 (copy), u3 (ref)
        while u57() do
            AssetIcon.Position = Position;
            AssetIcon.Rotation = Rotation;
            local v58 = u5:NextNumber(1, 3);
            local v59 = Tween(AssetIcon, {
                Position = Position - u2
            }, { v58 * 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out });
            u56:Add(v59);
            v59.Completed:Wait();

            if not u57() then
                break;
            end;

            local v60 = v58 * 0.3 / #u3;

            for _, v in ipairs(u3) do
                local v61 = Tween(AssetIcon, {
                    Rotation = Rotation + 12 * v
                }, { v60, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut });
                u56:Add(v61);
                v61.Completed:Wait();

                if not u57() then
                    break;
                end;
            end;

            if not u57() then
                break;
            end;

            local v62 = Tween(AssetIcon, {
                Position = Position
            }, { v58 * 0.45, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out });
            u56:Add(v62);
            v62.Completed:Wait();
            AssetIcon.Position = Position;
            AssetIcon.Rotation = Rotation;
        end;
    end));
end;

function u32.Prompt(p63, p64) -- Line: 282
    -- upvalues: AssetItem (copy), Asserts (copy), u6 (ref), TabController (copy), Trove (copy), Signal (copy), u32 (copy), ButtonFX (copy), StealButton (copy), u4 (copy)
    assert(AssetItem.AssetItemData(p63));

    if p64 ~= nil then
        Asserts.string(p64);
    end;

    if u6 then
        return false;
    end;

    u6 = true;
    local u65 = true;
    local u66 = false;
    local v67 = TabController.Get();
    local v68 = Trove.new();
    local u69 = v68:Add(Signal.new());
    u32._populate(v68, p63, p64);
    v68:Add(ButtonFX(StealButton, nil, function() -- Line: 299
        -- upvalues: u65 (ref), u66 (ref), TabController (ref), u69 (copy)
        if not u65 then
            return;
        end;

        u65 = false;
        u66 = true;
        TabController.CloseTab(true);
        u69:Fire();
    end));
    v68:Add(TabController.Closed:Connect(function(p70) -- Line: 309
        -- upvalues: u65 (ref), u69 (copy)
        if u65 and p70 == "StealDnaMessage" then
            u65 = false;
            u69:Fire();
        end;
    end));

    if not TabController.OpenTab("StealDnaMessage") then
        u4:AtWarning():Log("Steal DNA confirmation tab could not open");
        u65 = false;
        v68:Destroy();
        u6 = false;

        return false;
    end;

    u32._startStealAnimation(v68, function() -- Line: 324
        -- upvalues: u65 (ref)
        return u65;
    end);
    u32._startIconAnimation(v68, function() -- Line: 327
        -- upvalues: u65 (ref)
        return u65;
    end);
    u69:Wait();
    v68:Destroy();
    u6 = false;

    if not u66 and v67 ~= nil then
        TabController.OpenTab(v67, true);
    end;

    return u66;
end;

return u32;