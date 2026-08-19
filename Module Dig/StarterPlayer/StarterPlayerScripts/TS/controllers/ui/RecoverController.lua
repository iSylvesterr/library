-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local u1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "object-utils");
local FrameComponent = RuntimeLib.import(script, script.Parent.Parent.Parent, "components", "ui", "FrameComponent").FrameComponent;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local weightStyleFor = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "ui", "WeightStyles").weightStyleFor;
local ItemsEvents = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "ItemsNetwork").ItemsEvents;
local promptMonetizedItem = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "monetization", "promptMonetizedItem").promptMonetizedItem;
local v2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "gradient", "RobuxGradient");
local ROBUX_GRADIENT_COLOR = v2.ROBUX_GRADIENT_COLOR;
local ROBUX_GRADIENT_ROTATION = v2.ROBUX_GRADIENT_ROTATION;
local TextGradient = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "gradient", "TextGradient").TextGradient;
local ItemLabelStyles = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "itemLabels", "ItemLabelStyles").ItemLabelStyles;
local formatKg = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items").formatKg;
local RECOVERY_PRODUCTS = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "monetization", "ItemRecovery").RECOVERY_PRODUCTS;
local robuxIcon = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "symbols", "stringSymbols").robuxIcon;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local getMonetizedItemPrice = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "monetization", "getMonetizedItemPrice").getMonetizedItemPrice;
local u3 = setmetatable({}, {
    __tostring = function() -- Line: 26, Name: __tostring
        return "RecoverController";
    end
});
u3.__index = u3;

function u3.new(...) -- Line: 31
    -- upvalues: u3 (ref)
    local v4 = setmetatable({}, u3);

    return v4:constructor(...) or v4;
end;

function u3.constructor(p5) -- Line: 35
    p5.offerId = 0;
end;

function u3.onStart(u6) -- Line: 38
    -- upvalues: u1 (copy), RECOVERY_PRODUCTS (copy), getMonetizedItemPrice (copy), ItemsEvents (copy), FrameComponent (copy)
    u6:setupFrame();

    for _, v in u1.values(RECOVERY_PRODUCTS) do
        task.spawn(function() -- Line: 41
            -- upvalues: getMonetizedItemPrice (ref), v (copy)
            return getMonetizedItemPrice(v);
        end);
    end;

    ItemsEvents.recoveryOffered:connect(function(p7, p8) -- Line: 45
        -- upvalues: u6 (copy)
        return u6:onOffered(p7, p8);
    end);
    ItemsEvents.recoveryGranted:connect(function() -- Line: 48
        -- upvalues: u6 (copy)
        return u6:close();
    end);
    FrameComponent.onClosed.Event:Connect(function(p9) -- Line: 51
        -- upvalues: u6 (copy)
        if p9 ~= "Recover" then
            return nil;
        end;

        local v10 = u6;
        v10.offerId = v10.offerId + 1;
        u6.rarity = nil;
    end);
end;

function u3.setupFrame(u11) -- Line: 59
    -- upvalues: WFChain (copy), PlayerGui (copy)
    u11.frame = WFChain(PlayerGui, "Main", "Recover");
    u11.description = WFChain(u11.frame, "Description");
    WFChain(u11.frame, "Yes").Activated:Connect(function() -- Line: 62
        -- upvalues: u11 (copy)
        return u11:promptRecovery();
    end);
    WFChain(u11.frame, "No").Activated:Connect(function() -- Line: 65
        -- upvalues: u11 (copy)
        return u11:close();
    end);
end;

function u3.onOffered(u12, u13, u14) -- Line: 69
    -- upvalues: getMonetizedItemPrice (copy), RECOVERY_PRODUCTS (copy), FrameComponent (copy)
    u12.offerId = u12.offerId + 1;
    local offerId = u12.offerId;
    getMonetizedItemPrice(RECOVERY_PRODUCTS[u14]):andThen(function(p15) -- Line: 72
        -- upvalues: u12 (copy), offerId (copy), u14 (copy), u13 (copy), FrameComponent (ref)
        if u12.offerId ~= offerId then
            return nil;
        end;

        u12.rarity = u14;
        u12:render(u13, u14, p15);
        task.delay(0.5, function() -- Line: 78
            -- upvalues: u12 (ref), offerId (ref), FrameComponent (ref)
            if u12.offerId ~= offerId then
                return nil;
            end;

            FrameComponent:toggleFrame("Recover", true);
        end);
    end);
end;

function u3.render(p16, p17, p18, p19) -- Line: 86
    -- upvalues: weightStyleFor (copy), TextGradient (copy), ItemLabelStyles (copy), formatKg (copy), robuxIcon (copy), ROBUX_GRADIENT_COLOR (copy), ROBUX_GRADIENT_ROTATION (copy)
    local v20 = weightStyleFor(p17);
    TextGradient.applySegments(p16.description, {
        {
            text = "You lost a "
        },
        ItemLabelStyles.unknownRaritySegment(p18),
        {
            text = " "
        },
        {
            text = `[{formatKg(p17)}KG]`,
            color = v20.color,
            gradient = v20.gradient,
            animationTag = v20.animationTag
        },
        {
            text = " item recover it for "
        },
        {
            text = `{robuxIcon}{p19}`,
            gradient = ROBUX_GRADIENT_COLOR,
            rotation = ROBUX_GRADIENT_ROTATION
        },
        {
            text = "?"
        }
    });
end;

function u3.promptRecovery(p21) -- Line: 107
    -- upvalues: promptMonetizedItem (copy), RECOVERY_PRODUCTS (copy)
    if p21.rarity == nil then
        return nil;
    end;

    promptMonetizedItem(RECOVERY_PRODUCTS[p21.rarity]);
end;

function u3.close(p22) -- Line: 113
    -- upvalues: FrameComponent (copy)
    if p22.frame.Visible then
        FrameComponent:toggleFrame("Recover", false);
    end;
end;

Reflect.defineMetadata(u3, "identifier", "client/controllers/ui/RecoverController@RecoverController");
Reflect.defineMetadata(u3, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u3, "$:flamework@Controller", Controller, { {} });

return {
    RecoverController = u3
};