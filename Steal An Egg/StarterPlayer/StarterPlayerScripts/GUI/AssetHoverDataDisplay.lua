-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local AssetGenderUtil = require(ReplicatedStorage.Library.Util.AssetGenderUtil);
local AssetItemUtil = require(ReplicatedStorage.Library.Util.AssetItemUtil);
local AssetRuntime = require(ReplicatedStorage.Library.Types.AssetRuntime);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local HoverHighlight = require(ReplicatedStorage.Library.Client.WorldFX.HoverHighlight);
local ModelMouseHover = require(ReplicatedStorage.Library.Client.UI.ModelMouseHover);
local TouchTapTracker = require(ReplicatedStorage.Library.Client.Input.TouchTapTracker);
local Tween = require(ReplicatedStorage.Library.Functions.Tween);
local u1 = Color3.fromRGB(255, 0, 0);
local u2 = Color3.new(1, 1, 1);
local u3 = TweenInfo.new(0.65, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
local u4 = {};
local u5 = {};
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = 0;
local u10 = nil;
local u11 = nil;
local u12 = TouchTapTracker.new();
local u13 = nil;
local v14 = {};

local function getKey(p15) -- Line: 80
    return `{p15.OwnerUserId}:{p15.UID}`;
end;

local function activateActiveSteal(p16) -- Line: 84
    -- upvalues: u7 (ref), u4 (copy)
    local v17 = u7;

    if v17 == nil or p16 ~= nil and v17 ~= p16 then
        return;
    end;

    local v18 = u4[v17];

    if v18 == nil or v18.ActivateSteal == nil then
        return;
    end;

    v18.ActivateSteal();
end;

local function bindGui() -- Line: 96
    -- upvalues: u6 (ref), GUI (copy), u2 (copy), UserInputService (copy), u7 (ref), u4 (copy), u13 (ref), u12 (copy)
    local v19 = u6;

    if v19 ~= nil then
        return v19;
    end;

    local v20 = GUI.AssetHoverData();
    local v21 = v20:IsA("ScreenGui");
    assert(v21, "PlayerGui.AssetHoverData must be a ScreenGui");
    local Frame = v20.Frame;
    local v22 = Frame:IsA("GuiObject");
    assert(v22, "AssetHoverData.Frame must be a GuiObject");
    local CanvasGroup = Frame.CanvasGroup;
    local v23 = CanvasGroup:IsA("CanvasGroup");
    assert(v23, "AssetHoverData.Frame.CanvasGroup must be a CanvasGroup");
    local Weight = CanvasGroup.Weight;
    local v24 = Weight:IsA("TextLabel");
    assert(v24, "AssetHoverData.Frame.CanvasGroup.Weight must be a TextLabel");
    local Gender = CanvasGroup.Gender;
    local v25 = Gender:IsA("ImageLabel");
    assert(v25, "AssetHoverData.Frame.CanvasGroup.Gender must be an ImageLabel");
    local Steal = CanvasGroup.Steal;
    local v26 = Steal:IsA("Frame");
    assert(v26, "AssetHoverData.Frame.CanvasGroup.Steal must be a Frame");
    local ImageLabel = Steal.ImageLabel;
    local v27 = ImageLabel:IsA("ImageLabel");
    assert(v27, "AssetHoverData.Frame.CanvasGroup.Steal.ImageLabel must be an ImageLabel");
    local UIScale = Instance.new("UIScale");
    UIScale.Name = "DnaStealPulseScale";
    UIScale.Scale = 0.9;
    UIScale.Parent = ImageLabel;
    local v28 = {
        Root = v20,
        Frame = Frame,
        CanvasGroup = CanvasGroup,
        Weight = Weight,
        Gender = Gender,
        Steal = Steal,
        StealImage = ImageLabel,
        StealScale = UIScale
    };
    u6 = v28;
    v20.Enabled = false;
    Frame.Visible = false;
    CanvasGroup.GroupTransparency = 1;
    Steal.Active = false;
    Steal.Visible = false;
    ImageLabel.ImageColor3 = u2;
    UserInputService.InputBegan:Connect(function(p29, p30) -- Line: 138
        -- upvalues: u7 (ref), u4 (ref), u13 (ref), u12 (ref)
        if p30 then
            return;
        end;

        local UserInputType = p29.UserInputType;

        if UserInputType == Enum.UserInputType.MouseButton1 then
            local v31 = u7;

            if v31 ~= nil then
                local v32 = u4[v31];

                if v32 ~= nil then
                    if v32.ActivateSteal == nil then
                        return;
                    end;

                    v32.ActivateSteal();
                end;
            end;

            return;
        end;

        if UserInputType ~= Enum.UserInputType.Touch or u13 ~= nil then
            return;
        end;

        local v33 = u7;

        if v33 == nil then
            return;
        end;

        local v34 = u4[v33];

        if v34 == nil or v34.ActivateSteal == nil then
            return;
        end;

        u13 = v33;
        u12:Begin(p29);
    end);
    UserInputService.InputChanged:Connect(function(p35) -- Line: 161
        -- upvalues: u12 (ref)
        if p35.UserInputType == Enum.UserInputType.Touch and u12:IsTrackingInput(p35) then
            u12:Update(p35);
        end;
    end);
    UserInputService.InputEnded:Connect(function(p36, p37) -- Line: 166
        -- upvalues: u12 (ref), u13 (ref), u7 (ref), u4 (ref)
        if p36.UserInputType ~= Enum.UserInputType.Touch or not u12:IsTrackingInput(p36) then
            return;
        end;

        local v38 = u13;
        u13 = nil;

        if u12:Evaluate(p36, p37) and v38 ~= nil then
            local v39 = u7;

            if v39 ~= nil then
                if v38 ~= nil and v39 ~= v38 then
                    return;
                end;

                local v40 = u4[v39];

                if v40 ~= nil then
                    if v40.ActivateSteal == nil then
                        return;
                    end;

                    v40.ActivateSteal();
                end;
            end;
        end;
    end);

    return v28;
end;

local function stopStealPulse(p41) -- Line: 180
    -- upvalues: u10 (ref), u11 (ref), u2 (copy)
    local v42 = u10;
    u10 = nil;

    if v42 ~= nil then
        v42:Cancel();
        v42:Destroy();
    end;

    local v43 = u11;
    u11 = nil;

    if v43 ~= nil then
        v43:Cancel();
        v43:Destroy();
    end;

    p41.StealScale.Scale = 0.9;
    p41.StealImage.ImageColor3 = u2;
end;

local function setStealVisible(p44, p45) -- Line: 197
    -- upvalues: u13 (ref), u12 (copy), u10 (ref), u11 (ref), u2 (copy), TweenService (copy), u3 (copy), u1 (copy)
    if not p45 then
        u13 = nil;
        u12:Reset();
        local v46 = u10;
        u10 = nil;

        if v46 ~= nil then
            v46:Cancel();
            v46:Destroy();
        end;

        local v47 = u11;
        u11 = nil;

        if v47 ~= nil then
            v47:Cancel();
            v47:Destroy();
        end;

        p44.StealScale.Scale = 0.9;
        p44.StealImage.ImageColor3 = u2;
        p44.Steal.Visible = false;

        return;
    end;

    p44.Steal.Visible = true;

    if u10 ~= nil then
        return;
    end;

    local v48 = u10;
    u10 = nil;

    if v48 ~= nil then
        v48:Cancel();
        v48:Destroy();
    end;

    local v49 = u11;
    u11 = nil;

    if v49 ~= nil then
        v49:Cancel();
        v49:Destroy();
    end;

    p44.StealScale.Scale = 0.9;
    p44.StealImage.ImageColor3 = u2;
    local v50 = TweenService:Create(p44.StealScale, u3, {
        Scale = 1.25
    });
    local v51 = TweenService:Create(p44.StealImage, u3, {
        ImageColor3 = u1
    });
    u10 = v50;
    u11 = v51;
    v50:Play();
    v51:Play();
end;

local function clearActiveHighlight() -- Line: 222
    -- upvalues: u8 (ref), HoverHighlight (copy)
    local v52 = u8;
    u8 = nil;

    if v52 ~= nil then
        HoverHighlight.FadeOut(v52, 0.2);
    end;
end;

local function updateFramePosition(p53, p54) -- Line: 230
    p53.Frame.Position = UDim2.fromOffset(p54.X, p54.Y);
end;

local function updateStaticContent(p55, p56) -- Line: 234
    -- upvalues: AssetItemUtil (copy), AssetGenderUtil (copy)
    p55.Weight.Text = AssetItemUtil.GetVisualWeightKgDisplay(p56.Record.ItemData);
    p55.Gender.Image = AssetGenderUtil.GetIcon(AssetGenderUtil.ResolveForCategory(p56.Record.ItemData.Category, p56.Record.ItemData.Gender));
end;

local function setActiveEntry(p57, p58) -- Line: 241
    -- upvalues: u7 (ref), bindGui (copy), u13 (ref), u12 (copy), u10 (ref), u11 (ref), u2 (copy), u9 (ref), u8 (ref), HoverHighlight (copy), Tween (copy), setStealVisible (copy), AssetItemUtil (copy), AssetGenderUtil (copy)
    if p57 ~= nil then
        local v59 = bindGui();
        v59.Frame.Position = UDim2.fromOffset(p58.X, p58.Y);
        u9 = u9 + 1;
        v59.Root.Enabled = true;
        v59.Frame.Visible = true;
        setStealVisible(v59, p57.ActivateSteal ~= nil);

        if u7 ~= p57.Key then
            u7 = p57.Key;
            local v60 = u8;
            u8 = nil;

            if v60 ~= nil then
                HoverHighlight.FadeOut(v60, 0.2);
            end;

            u8 = HoverHighlight.FadeIn(p57.Model, "AssetHoverHighlight", 0.2);
            v59.Weight.Text = AssetItemUtil.GetVisualWeightKgDisplay(p57.Record.ItemData);
            v59.Gender.Image = AssetGenderUtil.GetIcon(AssetGenderUtil.ResolveForCategory(p57.Record.ItemData.Category, p57.Record.ItemData.Gender));
            v59.CanvasGroup.GroupTransparency = 1;
            Tween(v59.CanvasGroup, {
                GroupTransparency = 0
            }, { 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out });
        end;

        return;
    end;

    if u7 == nil then
        return;
    end;

    local u61 = bindGui();
    u61.Frame.Position = UDim2.fromOffset(p58.X, p58.Y);
    u7 = nil;
    u13 = nil;
    u12:Reset();
    local v62 = u10;
    u10 = nil;

    if v62 ~= nil then
        v62:Cancel();
        v62:Destroy();
    end;

    local v63 = u11;
    u11 = nil;

    if v63 ~= nil then
        v63:Cancel();
        v63:Destroy();
    end;

    u61.StealScale.Scale = 0.9;
    u61.StealImage.ImageColor3 = u2;
    u61.Steal.Visible = false;
    u9 = u9 + 1;
    local u64 = u9;
    local v65 = u8;
    u8 = nil;

    if v65 ~= nil then
        HoverHighlight.FadeOut(v65, 0.2);
    end;

    Tween(u61.CanvasGroup, {
        GroupTransparency = 1
    }, { 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out }).Completed:Once(function(p66) -- Line: 258
        -- upvalues: u7 (ref), u9 (ref), u64 (copy), u61 (copy)
        if p66 == Enum.PlaybackState.Completed and (u7 == nil and u9 == u64) then
            u61.Frame.Visible = false;
            u61.Root.Enabled = false;
        end;
    end);
end;

function v14.SetEntry(p67) -- Line: 299
    -- upvalues: AssetRuntime (copy), Asserts (copy), u4 (copy), u5 (copy)
    local v68 = AssetRuntime.SchemaValidation.RuntimeAssetRecord(p67.Record);
    assert(v68, "Invalid runtime asset record");
    Asserts.Model(p67.Model);
    local Record = p67.Record;
    local v69 = `{Record.OwnerUserId}:{Record.UID}`;
    u4[v69] = {
        Key = v69,
        Record = p67.Record,
        Model = p67.Model,
        ActivateSteal = p67.ActivateSteal
    };
    u5[v69] = p67.Model;
end;

function v14.RemoveEntry(p70, p71) -- Line: 313
    -- upvalues: Asserts (copy), u4 (copy), u5 (copy), u7 (ref), setActiveEntry (copy), UserInputService (copy)
    Asserts.number(p70);
    Asserts.string(p71);
    local v72 = `{p70}:{p71}`;
    u4[v72] = nil;
    u5[v72] = nil;

    if u7 == v72 then
        setActiveEntry(nil, UserInputService:GetMouseLocation());
    end;
end;

function v14.DestroyOwner(p73) -- Line: 325
    -- upvalues: Asserts (copy), u4 (copy), u5 (copy), u7 (ref), setActiveEntry (copy), UserInputService (copy)
    Asserts.number(p73);

    for i, v in pairs(u4) do
        if v.Record.OwnerUserId == p73 then
            u4[i] = nil;
            u5[i] = nil;

            if u7 == i then
                setActiveEntry(nil, UserInputService:GetMouseLocation());
            end;
        end;
    end;
end;

RunService.RenderStepped:Connect(function() -- Line: 288, Name: updateHover
    -- upvalues: UserInputService (copy), ModelMouseHover (copy), u5 (copy), u4 (copy), setActiveEntry (copy)
    local v74 = UserInputService:GetMouseLocation();
    local v75 = ModelMouseHover.GetHoveredKey(u5, v74, 200);
    local v76;

    if v75 == nil then
        v76 = nil;
    else
        v76 = u4[v75];
    end;

    setActiveEntry(v76, v74);
end);

return v14;