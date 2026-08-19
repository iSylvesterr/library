-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local GamepadService = v1.GamepadService;
local GuiService = v1.GuiService;
local UserInputService = v1.UserInputService;
local Workspace = v1.Workspace;
local Player = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").Player;

local function surfaceUv(p2, p3, p4) -- Line: 14
    local v5 = p2.CFrame:PointToObjectSpace(p4);
    local Size = p2.Size;

    if p3 == Enum.NormalId.Front then
        return Vector2.new(0.5 - v5.X / Size.X, 0.5 - v5.Y / Size.Y);
    end;

    if p3 == Enum.NormalId.Back then
        return Vector2.new(0.5 + v5.X / Size.X, 0.5 - v5.Y / Size.Y);
    end;

    if p3 == Enum.NormalId.Left then
        return Vector2.new(0.5 + v5.Z / Size.Z, 0.5 - v5.Y / Size.Y);
    end;

    if p3 == Enum.NormalId.Right then
        return Vector2.new(0.5 - v5.Z / Size.Z, 0.5 - v5.Y / Size.Y);
    end;

    if p3 == Enum.NormalId.Top then
        return Vector2.new(0.5 + v5.X / Size.X, 0.5 + v5.Z / Size.Z);
    end;

    return Vector2.new(0.5 + v5.X / Size.X, 0.5 - v5.Z / Size.Z);
end;

local function isShown(p6, p7) -- Line: 34
    if not p7.Enabled then
        return false;
    end;

    while p6 ~= nil and p6 ~= p7 do
        if p6:IsA("GuiObject") and not p6.Visible then
            return false;
        end;

        p6 = p6.Parent;
    end;

    return p6 == p7;
end;

local u8 = setmetatable({}, {
    __tostring = function() -- Line: 54, Name: __tostring
        return "SurfaceButtonController";
    end
});
u8.__index = u8;

function u8.new(...) -- Line: 59
    -- upvalues: u8 (ref)
    local v9 = setmetatable({}, u8);

    return v9:constructor(...) or v9;
end;

function u8.constructor(p10) -- Line: 63
    p10.entries = {};
end;

function u8.onStart(u11) -- Line: 66
    -- upvalues: UserInputService (copy), GamepadService (copy)
    UserInputService.InputBegan:Connect(function(p12) -- Line: 67
        -- upvalues: GamepadService (ref), u11 (copy)
        if p12.KeyCode ~= Enum.KeyCode.ButtonA or not GamepadService.GamepadCursorEnabled then
            return nil;
        end;

        u11:clickAtCursor();
    end);
end;

function u8.connect(u13, p14, u15) -- Line: 74
    local u16 = 0;

    local function v18() -- Line: 76
        -- upvalues: u16 (ref), u15 (copy)
        local v17 = os.clock();

        if v17 - u16 < 0.2 then
            return nil;
        end;

        u16 = v17;
        u15();
    end;

    local u19 = p14.Activated:Connect(v18);
    local v20 = p14:FindFirstAncestorWhichIsA("SurfaceGui");
    local u21 = v20 ~= nil and {
        button = p14,
        gui = v20,
        fire = v18
    } or nil;

    if u21 then
        u13.entries[u21] = true;
    end;

    return function() -- Line: 94
        -- upvalues: u19 (copy), u21 (copy), u13 (copy)
        u19:Disconnect();

        if u21 then
            u13.entries[u21] = nil;
        end;
    end;
end;

function u8.clickAtCursor(p22) -- Line: 101
    -- upvalues: Workspace (copy), UserInputService (copy), Player (copy)
    local CurrentCamera = Workspace.CurrentCamera;
    local v23 = not CurrentCamera;

    if not v23 then
        local v24 = 0;

        for _ in p22.entries do
            v24 = v24 + 1;
        end;

        if v24 == 0 then
            v23 = true;
        else
            v23 = false;
        end;
    end;

    if v23 then
        return nil;
    end;

    local v25 = UserInputService:GetMouseLocation();

    if p22:isCursorOverScreenGui(v25) then
        return nil;
    end;

    local v26 = CurrentCamera:ViewportPointToRay(v25.X, v25.Y);
    local v27 = RaycastParams.new();
    v27.FilterType = Enum.RaycastFilterType.Exclude;
    local Character = Player.Character;
    v27.FilterDescendantsInstances = Character and { Character } or {};
    v27.IgnoreWater = true;
    local v28 = Workspace:Raycast(v26.Origin, v26.Direction * 512, v27);

    if not v28 then
        return nil;
    end;

    for i in p22.entries do
        if p22:isUnderHit(i, v28) then
            i.fire();

            return nil;
        end;
    end;
end;

function u8.isCursorOverScreenGui(p29, p30) -- Line: 137
    -- upvalues: Player (copy), GuiService (copy)
    local v31 = Player:FindFirstChildOfClass("PlayerGui");

    if not v31 then
        return false;
    end;

    local v32 = GuiService:GetGuiInset();

    local function _(p33) -- Line: 146
        return p33.Active;
    end;

    for i, v in v31:GetGuiObjectsAtPosition(p30.X - v32.X, p30.Y - v32.Y) do
        local _ = i - 1;

        if v.Active then
            return true;
        end;
    end;

    return false;
end;

function u8.isUnderHit(p34, p35, p36) -- Line: 158
    -- upvalues: isShown (copy), surfaceUv (copy)
    local button = p35.button;
    local gui = p35.gui;
    local Adornee = gui.Adornee;
    local v37;

    if Adornee == nil then
        v37 = Adornee;
    else
        v37 = Adornee:IsA("BasePart");
    end;

    if v37 ~= true then
        Adornee = gui:FindFirstAncestorWhichIsA("BasePart");
    end;

    if Adornee == nil or Adornee ~= p36.Instance then
        return false;
    end;

    if not isShown(button, gui) then
        return false;
    end;

    local v38 = Adornee.CFrame:VectorToWorldSpace(Vector3.FromNormalId(gui.Face));

    if p36.Normal:Dot(v38) < 0.5 then
        return false;
    end;

    local v39 = surfaceUv(Adornee, gui.Face, p36.Position);

    if v39.X < 0 or (v39.X > 1 or (v39.Y < 0 or v39.Y > 1)) then
        return false;
    end;

    local AbsoluteSize = gui.AbsoluteSize;
    local v40 = Vector2.new(v39.X * AbsoluteSize.X, v39.Y * AbsoluteSize.Y);
    local AbsolutePosition = button.AbsolutePosition;
    local AbsoluteSize2 = button.AbsoluteSize;
    local v41;

    if v40.X >= AbsolutePosition.X and (v40.X <= AbsolutePosition.X + AbsoluteSize2.X and v40.Y >= AbsolutePosition.Y) then
        v41 = v40.Y <= AbsolutePosition.Y + AbsoluteSize2.Y;
    else
        v41 = false;
    end;

    return v41;
end;

Reflect.defineMetadata(u8, "identifier", "client/controllers/ui/SurfaceButtonController@SurfaceButtonController");
Reflect.defineMetadata(u8, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u8, "$:flamework@Controller", Controller, { {} });

return {
    SurfaceButtonController = u8
};