-- Decompiled with Potassium's decompiler.

local ContextActionService = game:GetService("ContextActionService");
local GuiService = game:GetService("GuiService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local InputIconsConfig = require(ReplicatedStorage.Library.InputIconsConfig);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Signal = require(ReplicatedStorage.Library.Signal);
local Variables = require(ReplicatedStorage.Library.Variables);
local u1 = table.freeze({
    ButtonA = Enum.KeyCode.ButtonA,
    ButtonB = Enum.KeyCode.ButtonB,
    ButtonX = Enum.KeyCode.ButtonX,
    ButtonY = Enum.KeyCode.ButtonY,
    ButtonLB = Enum.KeyCode.ButtonL1,
    ButtonLT = Enum.KeyCode.ButtonL2,
    ButtonLS = Enum.KeyCode.ButtonL3,
    ButtonRB = Enum.KeyCode.ButtonR1,
    ButtonRT = Enum.KeyCode.ButtonR2,
    ButtonRS = Enum.KeyCode.ButtonR3,
    ButtonStart = Enum.KeyCode.ButtonStart,
    ButtonSelect = Enum.KeyCode.ButtonSelect,
    DPadUp = Enum.KeyCode.DPadUp,
    DPadDown = Enum.KeyCode.DPadDown,
    DPadLeft = Enum.KeyCode.DPadLeft,
    DPadRight = Enum.KeyCode.DPadRight
});
local u2 = table.freeze({
    [Enum.KeyCode.ButtonA] = "ButtonA",
    [Enum.KeyCode.ButtonB] = "ButtonB",
    [Enum.KeyCode.ButtonX] = "ButtonX",
    [Enum.KeyCode.ButtonY] = "ButtonY",
    [Enum.KeyCode.ButtonL1] = "ButtonLB",
    [Enum.KeyCode.ButtonL2] = "ButtonLT",
    [Enum.KeyCode.ButtonL3] = "ButtonLS",
    [Enum.KeyCode.ButtonR1] = "ButtonRB",
    [Enum.KeyCode.ButtonR2] = "ButtonRT",
    [Enum.KeyCode.ButtonR3] = "ButtonRS",
    [Enum.KeyCode.ButtonStart] = "ButtonStart",
    [Enum.KeyCode.ButtonSelect] = "ButtonSelect",
    [Enum.KeyCode.DPadUp] = "DPadUp",
    [Enum.KeyCode.DPadDown] = "DPadDown",
    [Enum.KeyCode.DPadLeft] = "DPadLeft",
    [Enum.KeyCode.DPadRight] = "DPadRight"
});
local Value = Enum.ContextActionPriority.High.Value;
local u3 = table.freeze({
    Message = 1000,
    BuyMultiple = 1000,
    StealDnaMessage = 1000,
    PetList = 900,
    GrowingEggList = 900,
    DropHeldEgg = 200,
    RunButton = 100
});
local u4 = table.freeze({
    BackpackGui = true,
    Treadmill = true,
    TreadmillScreenButtonSwapLeft = true,
    TreadmillScreenButtonSwapRight = true,
    TreadmillScreenComments = true,
    TreadmillUI = true
});
local u5 = table.freeze({
    PetList = true,
    GrowingEggList = true
});
local ButtonB = Enum.KeyCode.ButtonB;
local u6 = table.freeze({
    Xbox = "B",
    PlayStation = "O"
});
local u7 = Log.new();
local u8 = GUI.PlayerGui();
local u9 = {};
local u10 = {};
local u11 = {};
local u12 = {};
local u13 = {};
local u14 = nil;
local u15 = nil;
local u16 = true;
local u17 = {};

local function consoleScreenOf(p18) -- Line: 120
    if p18:IsA("ScreenGui") then
        return p18;
    end;

    return p18:FindFirstAncestorOfClass("ScreenGui");
end;

local function consoleButtonOf(p19) -- Line: 127
    local Parent = p19.Parent;

    while Parent ~= nil and not Parent:IsA("ScreenGui") do
        if Parent:IsA("GuiButton") then
            return Parent;
        end;

        Parent = Parent.Parent;
    end;

    return nil;
end;

local function isExcluded(p20) -- Line: 138
    -- upvalues: u4 (copy)
    if not p20:IsA("LayerCollector") then
        p20 = p20:FindFirstAncestorWhichIsA("LayerCollector");
    end;

    local v21;

    if p20 == nil then
        v21 = false;
    else
        v21 = u4[p20.Name] == true;
    end;

    return v21;
end;

local function isVisible(p22) -- Line: 145
    while p22 ~= nil do
        if p22:IsA("ScreenGui") then
            return p22.Enabled;
        end;

        if p22:IsA("GuiObject") and not p22.Visible then
            return false;
        end;

        p22 = p22.Parent;
    end;

    return false;
end;

local function rootPriority(p23) -- Line: 159
    -- upvalues: u3 (copy)
    return u3[p23.Name] or p23.DisplayOrder;
end;

local function detectConsoleType() -- Line: 163
    -- upvalues: InputIconsConfig (copy)
    return InputIconsConfig.Platform();
end;

local function projectMarker(p24, p25) -- Line: 167
    -- upvalues: Variables (copy), u17 (copy)
    local v26 = Variables.Console and p24:GetAttribute("HideOnLoad") ~= true;
    p24.Visible = v26;

    if Variables.Console and p24:IsA("ImageLabel") then
        p24.Image = u17.GetImageForString(p25);

        return;
    end;

    if Variables.Console and p24:IsA("ImageButton") then
        p24.Image = u17.GetImageForString(p25);
    end;
end;

local function projectCloseImage(p27) -- Line: 178
    -- upvalues: u10 (copy), Variables (copy), InputIconsConfig (copy), ButtonB (copy)
    local v28 = assert(u10[p27], "Close image state must be registered before applying");

    if Variables.Console then
        p27.Image = InputIconsConfig.Image(ButtonB) or v28.Image;
        p27.Visible = true;

        return;
    end;

    p27.Image = v28.Image;
    p27.Visible = v28.Visible;
end;

local function projectCloseText(p29) -- Line: 189
    -- upvalues: u11 (copy), Variables (copy), u6 (copy), u15 (ref), InputIconsConfig (copy)
    local v30 = assert(u11[p29], "Close text state must be registered before applying");

    if Variables.Console then
        p29.Text = u6[u15 or InputIconsConfig.Platform()];
        p29.Visible = true;

        return;
    end;

    p29.Text = v30.Text;
    p29.Visible = v30.Visible;
end;

local function registerCloseText(u31) -- Line: 200
    -- upvalues: u11 (copy), Variables (copy), u6 (copy), u15 (ref), InputIconsConfig (copy)
    if u11[u31] == nil then
        u11[u31] = {
            Text = u31.Text,
            Visible = u31.Visible
        };
        u31.Destroying:Once(function() -- Line: 206
            -- upvalues: u11 (ref), u31 (copy)
            u11[u31] = nil;
        end);
    end;

    local v32 = assert(u11[u31], "Close text state must be registered before applying");

    if Variables.Console then
        u31.Text = u6[u15 or InputIconsConfig.Platform()];
        u31.Visible = true;

        return;
    end;

    u31.Text = v32.Text;
    u31.Visible = v32.Visible;
end;

local function removeButton(p33) -- Line: 213
    -- upvalues: u9 (copy), u13 (copy)
    u9[p33] = nil;

    for i, v in u13 do
        if v == p33 then
            u13[i] = nil;
        end;
    end;
end;

local function registerActionButton(u34, p35, p36, p37) -- Line: 222
    -- upvalues: u1 (copy), u9 (copy), u13 (copy)
    local v38 = u1[p35] ~= nil;
    local v39 = `Unknown console action "{p35}"`;
    assert(v38, v39);
    local v40;

    if u34:IsA("ScreenGui") then
        v40 = u34;
    else
        v40 = u34:FindFirstAncestorOfClass("ScreenGui");
    end;

    local v41 = `Console action button {u34:GetFullName()} must belong to a ScreenGui`;
    local v42 = assert(v40, v41);
    local v43 = u9[u34] == nil;
    u9[u34] = {
        Action = p35,
        Button = u34,
        Marker = p36,
        Screen = v42,
        IsClose = p37
    };

    if v43 then
        u34.Destroying:Once(function() -- Line: 235
            -- upvalues: u34 (copy), u9 (ref), u13 (ref)
            local v44 = u34;
            u9[v44] = nil;

            for i, v in u13 do
                if v == v44 then
                    u13[i] = nil;
                end;
            end;
        end);
    end;
end;

local function isRecordEligible(p45, p46) -- Line: 241
    -- upvalues: isVisible (copy), u14 (ref)
    if p45.Action ~= p46 or not isVisible(p45.Button) then
        return false;
    end;

    if p45.Marker == nil or p45.Marker.Visible then
        return u14 == nil and true or p45.Screen == u14;
    end;

    return false;
end;

local function actionTarget(p47) -- Line: 254
    -- upvalues: u9 (copy), isVisible (copy), u14 (ref), u3 (copy)
    local v48 = nil;

    for _, v in u9 do
        local v49;

        if v.Action == p47 and isVisible(v.Button) and (v.Marker == nil or v.Marker.Visible) then
            v49 = u14 == nil and true or v.Screen == u14;
        else
            v49 = false;
        end;

        if v49 then
            if v48 == nil then
                v48 = v;
            else
                local Screen = v.Screen;
                local v50 = u3[Screen.Name] or Screen.DisplayOrder;
                local Screen2 = v48.Screen;
                local v51 = u3[Screen2.Name] or Screen2.DisplayOrder;

                if v51 < v50 or v50 == v51 and (v48.IsClose and not v.IsClose) then
                    v48 = v;
                end;
            end;
        end;
    end;

    if v48 == nil then
        return nil;
    end;

    return v48.Button;
end;

local function nativeButtonAOwnsInput() -- Line: 273
    -- upvalues: GuiService (copy), isVisible (copy)
    local SelectedObject = GuiService.SelectedObject;
    local v52;

    if SelectedObject == nil then
        v52 = false;
    else
        v52 = isVisible(SelectedObject);
    end;

    return v52;
end;

local function onInputBegan(p53, p54) -- Line: 278
    -- upvalues: Variables (copy), u16 (ref), u2 (copy), GuiService (copy), isVisible (copy), actionTarget (copy), u7 (copy), u14 (ref), u13 (copy), Signal (copy)
    if not Variables.Console or (p54 or not u16) then
        return;
    end;

    local v55 = u2[p53.KeyCode];

    if v55 == nil then
        return;
    end;

    if v55 == "ButtonA" then
        local SelectedObject = GuiService.SelectedObject;
        local v56;

        if SelectedObject == nil then
            v56 = false;
        else
            v56 = isVisible(SelectedObject);
        end;

        if v56 then
            return;
        end;
    end;

    local v57 = actionTarget(v55);

    if v57 == nil then
        u7:AtDebug():Log((`No console target for {v55}: active={u14 == nil and "none" or u14.Name}, selected={GuiService.SelectedObject == nil and "none" or GuiService.SelectedObject:GetFullName()}`));

        return;
    end;

    u13[p53.KeyCode] = v57;
    Signal.Fire("Console: Pressed", v55);
    Signal.Fire("Console: Pressed Button", v57, v55);
end;

local function onInputEnded(p58, p59) -- Line: 300
    -- upvalues: Variables (copy), u2 (copy), u13 (copy), isVisible (copy), Signal (copy)
    if not Variables.Console then
        return;
    end;

    local v60 = u2[p58.KeyCode];

    if v60 == nil then
        return;
    end;

    local v61 = u13[p58.KeyCode];
    u13[p58.KeyCode] = nil;

    if v61 == nil or not (v61.Active and isVisible(v61)) then
        return;
    end;

    Signal.Fire("Console: Released", v60);
    Signal.Fire("Console: Released Button", v61, v60);
    Signal.Fire("Console: Full Press", v60);
end;

function u17.GetConsoleType() -- Line: 344
    -- upvalues: u15 (ref)
    return u15;
end;

function u17.GetImageForString(p62) -- Line: 348
    -- upvalues: Asserts (copy), u1 (copy), u12 (copy), InputIconsConfig (copy)
    Asserts.string(p62);
    local v63 = u1[p62];
    local v64 = `Unknown console action "{p62}"`;
    local v65 = assert(v63, v64);
    local v66 = u12[p62];

    if v66 ~= nil then
        return v66;
    end;

    local v67 = InputIconsConfig.Image(v65) or "";
    u12[p62] = v67;

    return v67;
end;

function u17.ElementIsVisibleOnScreen(p68) -- Line: 360
    -- upvalues: Asserts (copy), isVisible (copy)
    Asserts.Instance(p68);

    return isVisible(p68);
end;

function u17.ConfigureCloseButton(p69) -- Line: 365
    -- upvalues: Asserts (copy), u4 (copy), u10 (copy), u17 (copy), Variables (copy), InputIconsConfig (copy), ButtonB (copy)
    Asserts.GuiButton(p69);
    local v70;

    if p69:IsA("LayerCollector") then
        v70 = p69;
    else
        v70 = p69:FindFirstAncestorWhichIsA("LayerCollector");
    end;

    local v71;

    if v70 == nil then
        v71 = false;
    else
        v71 = u4[v70.Name] == true;
    end;

    if v71 then
        return;
    end;

    local TextButton = p69:FindFirstChild("TextButton");
    local v72;

    if TextButton == nil then
        v72 = false;
    else
        v72 = TextButton:IsA("ImageLabel");
    end;

    local v73 = `{p69:GetFullName()}.TextButton must be an ImageLabel`;
    assert(v72, v73);

    if u10[TextButton] == nil then
        u10[TextButton] = {
            Image = TextButton.Image,
            Visible = TextButton.Visible
        };
        TextButton.Destroying:Once(function() -- Line: 377
            -- upvalues: u10 (ref), TextButton (copy)
            u10[TextButton] = nil;
        end);
    end;

    u17.RegisterCloseButton(p69);
    local v74 = assert(u10[TextButton], "Close image state must be registered before applying");

    if Variables.Console then
        TextButton.Image = InputIconsConfig.Image(ButtonB) or v74.Image;
        TextButton.Visible = true;

        return;
    end;

    TextButton.Image = v74.Image;
    TextButton.Visible = v74.Visible;
end;

function u17.RegisterCloseButton(p75) -- Line: 385
    -- upvalues: Asserts (copy), u4 (copy), u5 (copy), registerCloseText (copy), registerActionButton (copy)
    Asserts.GuiButton(p75);
    local v76;

    if p75:IsA("LayerCollector") then
        v76 = p75;
    else
        v76 = p75:FindFirstAncestorWhichIsA("LayerCollector");
    end;

    local v77;

    if v76 == nil then
        v77 = false;
    else
        v77 = u4[v76.Name] == true;
    end;

    if v77 then
        return;
    end;

    local v78;

    if p75:IsA("ScreenGui") then
        v78 = p75;
    else
        v78 = p75:FindFirstAncestorOfClass("ScreenGui");
    end;

    local v79 = `Close button {p75:GetFullName()} must belong to a ScreenGui`;

    if u5[assert(v78, v79).Name] then
        local TextLabel = p75:FindFirstChild("TextLabel");
        local v80;

        if TextLabel == nil then
            v80 = false;
        else
            v80 = TextLabel:IsA("TextLabel");
        end;

        local v81 = `{p75:GetFullName()}.TextLabel must be a TextLabel`;
        assert(v80, v81);
        local TextLabel2 = TextLabel:FindFirstChild("TextLabel");
        registerCloseText(TextLabel);

        if TextLabel2 ~= nil then
            local v82 = TextLabel2:IsA("TextLabel");
            local v83 = `{TextLabel:GetFullName()}.TextLabel must be a TextLabel when present`;
            assert(v82, v83);
            registerCloseText(TextLabel2);
        end;
    end;

    registerActionButton(p75, "ButtonB", nil, true);
end;

function u17.ObserveInstance(p84) -- Line: 404
    -- upvalues: u4 (copy), u5 (copy), u17 (copy), Asserts (copy), consoleButtonOf (copy), registerActionButton (copy), projectMarker (copy)
    local v85;

    if p84:IsA("LayerCollector") then
        v85 = p84;
    else
        v85 = p84:FindFirstAncestorWhichIsA("LayerCollector");
    end;

    local v86;

    if v85 == nil then
        v86 = false;
    else
        v86 = u4[v85.Name] == true;
    end;

    if v86 then
        return;
    end;

    if p84:IsA("GuiButton") and p84.Name == "Close" then
        local v87;

        if p84:IsA("ScreenGui") then
            v87 = p84;
        else
            v87 = p84:FindFirstAncestorOfClass("ScreenGui");
        end;

        if u5[assert(v87, "Observed close button must belong to a ScreenGui").Name] then
            u17.RegisterCloseButton(p84);

            return;
        end;

        u17.ConfigureCloseButton(p84);

        return;
    end;

    if not p84:IsA("GuiObject") or p84.Name ~= "ConsoleButton" then
        return;
    end;

    local v88 = p84:GetAttribute("ConsoleButton");
    Asserts.string(v88);
    local v89 = consoleButtonOf(p84);
    local v90 = `{p84:GetFullName()} must be below a GuiButton`;
    registerActionButton(assert(v89, v90), v88, p84, false);
    projectMarker(p84, v88);
end;

function u17.SetMarkerActionsEnabled(p91) -- Line: 428
    -- upvalues: Asserts (copy), u16 (ref), u13 (copy)
    Asserts.boolean(p91);
    u16 = p91;

    if not p91 then
        table.clear(u13);
    end;
end;

function u17.SetActiveInterface(p92) -- Line: 436
    -- upvalues: u8 (copy), u14 (ref)
    if p92 ~= nil then
        local v93 = p92:IsDescendantOf(u8);
        assert(v93, "Active console interface must belong to the local PlayerGui");
    end;

    u14 = p92;
end;

function u17.UpdateInterface(p94) -- Line: 443
    -- upvalues: Variables (copy), u15 (ref), InputIconsConfig (copy), u12 (copy), u8 (copy), u17 (copy), u10 (copy), ButtonB (copy), u11 (copy), u6 (copy), u9 (copy), projectMarker (copy), Signal (copy)
    local v95;

    if (p94 or Variables.Platform) == "Console" then
        v95 = InputIconsConfig.Platform();
    else
        v95 = nil;
    end;

    u15 = v95;
    table.clear(u12);

    for _, descendant in u8:GetDescendants() do
        u17.ObserveInstance(descendant);
    end;

    for i in u10 do
        if i.Parent ~= nil then
            local v96 = assert(u10[i], "Close image state must be registered before applying");

            if Variables.Console then
                i.Image = InputIconsConfig.Image(ButtonB) or v96.Image;
                i.Visible = true;
            else
                i.Image = v96.Image;
                i.Visible = v96.Visible;
            end;
        end;
    end;

    for i in u11 do
        if i.Parent ~= nil then
            local v97 = assert(u11[i], "Close text state must be registered before applying");

            if Variables.Console then
                i.Text = u6[u15 or InputIconsConfig.Platform()];
                i.Visible = true;
            else
                i.Text = v97.Text;
                i.Visible = v97.Visible;
            end;
        end;
    end;

    for _, v in u9 do
        if v.Marker ~= nil then
            projectMarker(v.Marker, v.Action);
        end;
    end;

    Signal.Fire("Console Updated");
end;

function u17.IsJumpPermitted() -- Line: 469
    return true;
end;

Signal.Fired("Changed Platform"):Connect(u17.UpdateInterface);
InputIconsConfig.Changed:Connect(function() -- Line: 478
    -- upvalues: u17 (copy)
    u17.UpdateInterface();
end);
Signal.Invoked("Console: Get Console Type").OnInvoke = u17.GetConsoleType;
Signal.Invoked("Console: Get Image For String").OnInvoke = u17.GetImageForString;
Signal.Invoked("Console: Element Visible On Screen").OnInvoke = u17.ElementIsVisibleOnScreen;

Signal.Invoked("Console: Button Visible on Screen").OnInvoke = function(p98) -- Line: 484
    -- upvalues: actionTarget (copy)
    local v99 = actionTarget(p98);
    local v100 = v99 ~= nil;

    if v99 == nil then
        return v100, {};
    end;

    return v100, { v99 };
end;

local v101 = {};

local function onMarkerAction(p102, p103, p104) -- Line: 319
    -- upvalues: onInputBegan (copy), u13 (copy), onInputEnded (copy)
    if p103 == Enum.UserInputState.Begin then
        onInputBegan(p104, false);

        if u13[p104.KeyCode] == nil then
            return Enum.ContextActionResult.Pass;
        end;

        return Enum.ContextActionResult.Sink;
    end;

    local v105 = u13[p104.KeyCode] ~= nil;

    if p103 == Enum.UserInputState.Cancel then
        u13[p104.KeyCode] = nil;
    else
        onInputEnded(p104, false);
    end;

    if v105 then
        return Enum.ContextActionResult.Sink;
    end;

    return Enum.ContextActionResult.Pass;
end;

for i, v in u1 do
    if i ~= "ButtonStart" then
        table.insert(v101, v);
    end;
end;

ContextActionService:BindActionAtPriority("ConsoleCmdsMarkerActions", onMarkerAction, false, Value, table.unpack(v101));
u7:AtInfo():Log("Console command routing initialized");

return u17;