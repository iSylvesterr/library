-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local TextService = v1.TextService;
local UserInputService = v1.UserInputService;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local TextGradient = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "gradient", "TextGradient").TextGradient;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 18, Name: __tostring
        return "BenefitTooltipController";
    end
});
u2.__index = u2;

function u2.new(...) -- Line: 23
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4) -- Line: 27
    p4.widths = {};
    p4.following = false;
end;

function u2.onStart(p5) -- Line: 31
    -- upvalues: WFChain (copy), PlayerGui (copy)
    p5.gui = WFChain(PlayerGui, "HUD");
    p5.frame = WFChain(p5.gui, "BenefitTooltip");
    p5.title = WFChain(p5.frame, "Title");
    p5.description = WFChain(p5.frame, "Description");
    p5.baseSize = p5.frame.Size;
    p5.frame.Active = false;
    p5.frame.ZIndex = 50;
    p5.title.ZIndex = 51;
    p5.description.ZIndex = 51;
    p5.frame.Visible = false;
end;

function u2.onRender(p6) -- Line: 43
    -- upvalues: UserInputService (copy)
    if not (p6.following and p6.frame.Visible) then
        return nil;
    end;

    p6:moveTo(UserInputService:GetMouseLocation());
end;

function u2.bind(u7, u8, u9, u10) -- Line: 49
    u8.Active = true;
    u8.MouseEnter:Connect(function() -- Line: 51
        -- upvalues: u7 (copy), u9 (copy), u10 (copy)
        return u7:followCursor(u9, u10());
    end);
    u8.MouseLeave:Connect(function() -- Line: 54
        -- upvalues: u7 (copy)
        if u7.following then
            u7:hide();
        end;
    end);
    u8.Activated:Connect(function() -- Line: 59
        -- upvalues: u7 (copy), u8 (copy), u9 (copy), u10 (copy)
        return u7:pinTo(u8, u9, u10());
    end);
end;

function u2.followCursor(p11, p12, p13) -- Line: 63
    -- upvalues: UserInputService (copy)
    if UserInputService:GetLastInputType() == Enum.UserInputType.Touch then
        return nil;
    end;

    local dismissConnection = p11.dismissConnection;

    if dismissConnection ~= nil then
        dismissConnection:Disconnect();
    end;

    p11.dismissConnection = nil;
    p11.following = true;
    p11:moveTo(UserInputService:GetMouseLocation());
    p11:show(p12, p13);
end;

function u2.pinTo(u14, p15, p16, p17) -- Line: 76
    -- upvalues: UserInputService (copy)
    if UserInputService:GetLastInputType() ~= Enum.UserInputType.Touch then
        return nil;
    end;

    local dismissConnection = u14.dismissConnection;

    if dismissConnection ~= nil then
        dismissConnection:Disconnect();
    end;

    u14.following = false;
    u14:moveTo(p15.AbsolutePosition + Vector2.new(p15.AbsoluteSize.X, 0));
    u14:show(p16, p17);
    task.defer(function() -- Line: 90
        -- upvalues: u14 (copy), UserInputService (ref)
        if not u14.frame.Visible then
            return nil;
        end;

        u14.dismissConnection = UserInputService.InputBegan:Connect(function() -- Line: 94
            -- upvalues: u14 (ref)
            return u14:hide();
        end);
    end);
end;

function u2.show(p18, p19, p20) -- Line: 99
    -- upvalues: TextGradient (copy)
    p18.title.Text = p19.title;
    p18.description.Text = p20;
    TextGradient.apply(p18.title, p19.gradient, p19.rotation);
    TextGradient.apply(p18.description, p19.gradient, p19.rotation);
    p18.frame.Visible = true;
    p18:fitTo(p19.title, p20);
end;

function u2.hide(p21) -- Line: 107
    p21.frame.Visible = false;
    p21.following = false;
    local dismissConnection = p21.dismissConnection;

    if dismissConnection ~= nil then
        dismissConnection:Disconnect();
    end;

    p21.dismissConnection = nil;
end;

function u2.moveTo(p22, p23) -- Line: 116
    p22.frame.Position = UDim2.fromOffset(p23.X - 6, p23.Y - 6);
end;

function u2.fitTo(p24, p25, p26) -- Line: 119
    local AbsoluteSize = p24.gui.AbsoluteSize;
    local v27 = p24.baseSize.Y.Scale * 0.660133302 * AbsoluteSize.Y;
    local v28 = p24:measure(p25, v27);
    local v29 = math.max(v28, p24:measure(p26, v27));
    local v30 = math.max(p24.baseSize.X.Scale * AbsoluteSize.X, v29 / 0.873956621);
    p24.frame.Size = UDim2.fromScale(v30 / AbsoluteSize.X, p24.baseSize.Y.Scale);
end;

function u2.measure(p31, p32, p33) -- Line: 126
    -- upvalues: TextService (copy)
    local v34 = `{math.round(p33)}|{p32}`;
    local v35 = p31.widths[v34];

    if v35 ~= nil then
        return v35;
    end;

    local GetTextBoundsParams = Instance.new("GetTextBoundsParams");
    GetTextBoundsParams.Text = p32;
    GetTextBoundsParams.Font = p31.description.FontFace;
    GetTextBoundsParams.Size = p33;
    local success, result = pcall(function() -- Line: 136
        -- upvalues: TextService (ref), GetTextBoundsParams (copy)
        return TextService:GetTextBoundsAsync(GetTextBoundsParams);
    end);
    GetTextBoundsParams:Destroy();
    local v36 = not success and 0 or result.X;
    p31.widths[v34] = v36;

    return v36;
end;

Reflect.defineMetadata(u2, "identifier", "client/controllers/ui/BenefitTooltipController@BenefitTooltipController");
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender" });
Reflect.decorate(u2, "$:flamework@Controller", Controller, { {} });

return {
    BenefitTooltipController = u2
};