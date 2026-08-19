-- Decompiled with Potassium's decompiler.

local u1 = {};
local ContextActionService = game:GetService("ContextActionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local DataController = require(ReplicatedStorage.Controllers.DataController);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Pages = require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages);
local KeybindParser = require(script:WaitForChild("KeybindParser"));
local Actions = script:WaitForChild("Actions");
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {
    ScrollWheelUp = nil,
    ScrollWheelDown = nil
};

local function handleInput(p6, p7, p8) -- Line: 47
    -- upvalues: u4 (copy), MenuState (copy), u3 (copy)
    local v9 = u4[p6];

    if not v9 then
        return;
    end;

    local v10 = MenuState.GetMenuFrame();
    local v11 = MenuState.GetCurrentScreen();
    local v12 = MenuState.GetMainGui();

    if v12 then
        v12 = v12:FindFirstChild("Gameplay");
    end;

    local v13;

    if v12 then
        v13 = v12:FindFirstChild("Bottom");
    else
        v13 = v12;
    end;

    if v12 then
        v12 = v12:FindFirstChild("Middle");
    end;

    if v12 then
        v12 = v12:FindFirstChild("TeamSelection");
    end;

    local v14 = v12 and v12:IsA("GuiObject") and (v12.Visible and (v13 and v13:IsA("GuiObject"))) and not v13.Visible;

    if ((v11 ~= nil or v10 and v10.Visible == true) and true or v14 == true) and (v9.Category ~= "UI Keys" and v9.Category ~= "Communication Options" and p7 == Enum.UserInputState.Begin) then
        v9.IsActive = false;

        return;
    end;

    if u3[v9.Group] ~= true then
        if p7 ~= Enum.UserInputState.Begin and v9.IsActive then
            v9.IsActive = false;
            task.spawn(v9.Callback, p7, p8);
        end;

        return;
    end;

    v9.IsActive = p7 == Enum.UserInputState.Begin;
    task.spawn(v9.Callback, p7, p8);
end;

local function handleScrollWheelInput(p15, p16) -- Line: 92
    -- upvalues: handleInput (copy)
    if not p15 then
        return;
    end;

    handleInput(p15, Enum.UserInputState.Begin, {
        UserInputType = Enum.UserInputType.MouseWheel,
        Delta = Vector3.new(0, p16, 0)
    });
    task.defer(handleInput, p15, Enum.UserInputState.End, {
        UserInputType = Enum.UserInputType.MouseWheel,
        Delta = Vector3.new(0, p16, 0)
    });
end;

local function unbindActionKeys(p17) -- Line: 117
    -- upvalues: u4 (copy), ContextActionService (copy), u5 (copy), u2 (copy)
    local v18 = u4[p17];

    if not v18 then
        return;
    end;

    ContextActionService:UnbindAction(p17);

    for _, v in ipairs(v18.Keybinds) do
        if typeof(v) == "string" then
            if v == "ScrollWheelUp" and u5.ScrollWheelUp == p17 then
                u5.ScrollWheelUp = nil;
            elseif v == "ScrollWheelDown" and u5.ScrollWheelDown == p17 then
                u5.ScrollWheelDown = nil;
            end;
        elseif u2[v] == p17 then
            u2[v] = nil;
        end;
    end;

    v18.Keybinds = {};
end;

function u1.registerAction(p19) -- Line: 145
    -- upvalues: u4 (copy)
    u4[p19.Name] = {
        IsActive = false,
        Category = p19.Category,
        Callback = p19.Callback,
        Group = p19.Group,
        BindPriority = p19.BindPriority,
        Name = p19.Name,
        Keybinds = {}
    };
end;

function u1.bindKeybinds(u20, p21) -- Line: 159
    -- upvalues: u4 (copy), unbindActionKeys (copy), u5 (copy), u2 (copy), handleInput (copy), ContextActionService (copy)
    local v22 = u4[u20];

    if not v22 then
        return;
    end;

    unbindActionKeys(u20);
    local v23 = {};
    local v24 = {};

    for _, v in ipairs(p21) do
        if v then
            if typeof(v) == "string" then
                if v == "ScrollWheelUp" then
                    if u5.ScrollWheelUp then
                        warn((`[InputController] {u20}: ScrollWheelUp is already bound to {u5.ScrollWheelUp}, keybind dropped`));
                    else
                        table.insert(v23, v);
                        u5.ScrollWheelUp = u20;
                    end;
                elseif v == "ScrollWheelDown" then
                    if u5.ScrollWheelDown then
                        warn((`[InputController] {u20}: ScrollWheelDown is already bound to {u5.ScrollWheelDown}, keybind dropped`));
                    else
                        table.insert(v23, v);
                        u5.ScrollWheelDown = u20;
                    end;
                end;
            else
                local v25 = u2[v];

                if v25 then
                    warn((`[InputController] {u20}: {tostring(v)} is already bound to {v25}, keybind dropped`));
                else
                    table.insert(v23, v);
                    table.insert(v24, v);
                    u2[v] = u20;
                end;
            end;
        end;
    end;

    v22.Keybinds = v23;

    if #v24 > 0 then
        local function v29(p26, p27, p28) -- Line: 212
            -- upvalues: handleInput (ref), u20 (copy)
            handleInput(u20, p27, p28);
        end;

        if v22.BindPriority ~= nil then
            ContextActionService:BindActionAtPriority(u20, v29, false, v22.BindPriority, table.unpack(v24));

            return;
        end;

        ContextActionService:BindAction(u20, v29, false, table.unpack(v24));
    end;
end;

function u1.loadActionsFromDatabase(p30) -- Line: 232
    -- upvalues: Pages (copy), unbindActionKeys (copy), KeybindParser (copy), u1 (copy)
    local v31 = {};

    for _, v in pairs(p30) do
        for i, v2 in pairs(v) do
            if typeof(v2) == "table" then
                local v32 = Pages.GetSetting("Keybinds", i);

                if v32 and v32.IsEnabled == false then
                    unbindActionKeys(i);
                else
                    local v33 = {};
                    local v34 = v2.Computer and v2.Computer ~= "" and KeybindParser.parse(v2.Computer);

                    if v34 then
                        table.insert(v33, v34);
                    end;

                    local v35 = v2.Console and v2.Console ~= "" and KeybindParser.parse(v2.Console);

                    if v35 then
                        table.insert(v33, v35);
                    end;

                    v31[i] = v33;
                end;
            end;
        end;
    end;

    for i in pairs(v31) do
        unbindActionKeys(i);
    end;

    for i, v in pairs(v31) do
        u1.bindKeybinds(i, v);
    end;
end;

function u1.isActionActive(p36) -- Line: 285
    -- upvalues: u4 (copy)
    local v37 = u4[p36];

    return v37 and v37.IsActive or false;
end;

function u1.enableGroup(p38) -- Line: 292
    -- upvalues: u3 (copy)
    u3[p38] = true;
end;

function u1.disableGroup(p39) -- Line: 298
    -- upvalues: u3 (copy)
    u3[p39] = nil;
end;

function u1.GetActionKeybind(p40) -- Line: 304
    -- upvalues: u4 (copy)
    local v41 = u4[p40];

    if not v41 or #v41.Keybinds == 0 then
        return nil;
    end;

    local v42 = v41.Keybinds[1];

    if typeof(v42) == "string" then
        return v42;
    end;

    return tostring(v42):match("%.(%w+)$") or tostring(v42);
end;

function u1.Initialize() -- Line: 323
    -- upvalues: Actions (copy), u1 (copy), LocalPlayer (copy), ContextActionService (copy), DataController (copy), Router (copy)
    for _, child in ipairs(Actions:GetChildren()) do
        if child:IsA("ModuleScript") then
            u1.registerAction((require(child)));
        end;
    end;

    u1.enableGroup("Default");
    LocalPlayer.CharacterAdded:Connect(function(p43) -- Line: 335
        -- upvalues: ContextActionService (ref)
        ContextActionService:UnbindAction("jumpAction");
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse", function(p44) -- Line: 340
        -- upvalues: u1 (ref)
        if not p44 then
            return;
        end;

        u1.loadActionsFromDatabase(p44);
    end);
    Router.observerRouter("RebindKeybinds", function() -- Line: 348
        -- upvalues: DataController (ref), LocalPlayer (ref), u1 (ref)
        local v45 = DataController.Get(LocalPlayer, "Settings.Keyboard/Mouse");

        if not v45 then
            return false;
        end;

        u1.loadActionsFromDatabase(v45);

        return true;
    end);
end;

function u1.getActionKeybinds(p46) -- Line: 360
    -- upvalues: u4 (copy)
    local v47 = u4[p46];

    if not v47 then
        return {};
    end;

    local v48 = {};

    for _, v in ipairs(v47.Keybinds) do
        if typeof(v) ~= "string" then
            table.insert(v48, v);
        end;
    end;

    return v48;
end;

function u1.isBindingPressed(p49) -- Line: 376
    -- upvalues: GetUserPlatform (copy), UserInputService (copy)
    if typeof(p49) == "string" then
        return false;
    end;

    if typeof(p49) ~= "EnumItem" then
        return false;
    end;

    if p49.EnumType ~= Enum.KeyCode then
        if p49.EnumType == Enum.UserInputType then
            return UserInputService:IsMouseButtonPressed(p49);
        end;

        return false;
    end;

    if p49 ~= Enum.KeyCode.ButtonR2 and p49 ~= Enum.KeyCode.ButtonL2 or not table.find(GetUserPlatform(), "Console") then
        return UserInputService:IsKeyDown(p49);
    end;

    local v50 = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1);

    for _, v in pairs(v50) do
        if v.KeyCode == p49 then
            return v.Position.Z > 0.3;
        end;
    end;

    return false;
end;

function u1.isActionPressed(p51, p52) -- Line: 412
    -- upvalues: u1 (copy)
    local v53 = u1.getActionKeybinds(p51);

    if #v53 == 0 then
        if not p52 or #p52 <= 0 then
            return false;
        end;
    else
        p52 = v53;
    end;

    for _, v in ipairs(p52) do
        if u1.isBindingPressed(v) then
            return true;
        end;
    end;

    return false;
end;

function u1.Start() -- Line: 442
    -- upvalues: UserInputService (copy), handleScrollWheelInput (copy), u5 (copy)
    UserInputService.InputChanged:Connect(function(p54) -- Line: 443
        -- upvalues: handleScrollWheelInput (ref), u5 (ref)
        if p54.UserInputType ~= Enum.UserInputType.MouseWheel then
            return;
        end;

        local Z = p54.Position.Z;

        if Z > 0 then
            handleScrollWheelInput(u5.ScrollWheelUp, 1);

            return;
        end;

        if Z < 0 then
            handleScrollWheelInput(u5.ScrollWheelDown, -1);
        end;
    end);
end;

return u1;