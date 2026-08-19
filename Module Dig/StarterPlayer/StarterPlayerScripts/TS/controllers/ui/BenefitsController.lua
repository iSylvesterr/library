-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "ui", "Benefits");
local BENEFIT_STYLES = v1.BENEFIT_STYLES;
local LUCK_PASS_STYLE = v1.LUCK_PASS_STYLE;
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "luck", "LuckConfig");
local latestExpiry = v2.latestExpiry;
local sumBoosts = v2.sumBoosts;
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "monetization", "Passes");
local DIG_POWER_PASS_NAME = v3.DIG_POWER_PASS_NAME;
local GOLD_PASS_NAME = v3.GOLD_PASS_NAME;
local WALK_SPEED_PASS_NAME = v3.WALK_SPEED_PASS_NAME;
local ownsPass = v3.ownsPass;
local passLuckFor = v3.passLuckFor;
local hasVip = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "monetization", "Vip").hasVip;
local formatBenefitTimer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "formatting", "formatSeconds").formatBenefitTimer;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u4 = setmetatable({}, {
    __tostring = function() -- Line: 26, Name: __tostring
        return "BenefitsController";
    end
});
u4.__index = u4;

function u4.new(...) -- Line: 31
    -- upvalues: u4 (ref)
    local v5 = setmetatable({}, u4);

    return v5:constructor(...) or v5;
end;

function u4.constructor(p6, p7, p8, p9) -- Line: 35
    p6.dataController = p7;
    p6.luck = p8;
    p6.tooltip = p9;
    p6.rows = {};
    p6.descriptions = {};
    p6.personalBoosts = {};
    p6.sinceRefresh = 0;
end;

function u4.onStart(p10) -- Line: 44
    -- upvalues: WFChain (copy), PlayerGui (copy)
    p10.container = WFChain(PlayerGui, "HUD", "Benefits");
    p10.template = WFChain(p10.container, "Template");
    p10.template.Visible = false;
    local v11 = p10.dataController:getData();
    p10.data = v11;
    p10.personalBoosts = v11.LuckBoosts;
    p10:refresh();
end;

function u4.onDataChanged(p12, p13, p14) -- Line: 53
    if table.find(p13, "LuckBoosts") == nil and table.find(p13, "Gamepasses") == nil then
        return nil;
    end;

    p12.data = p14;
    p12.personalBoosts = p14.LuckBoosts;
    p12:refresh();
end;

function u4.onTick(p15, p16) -- Line: 61
    p15.sinceRefresh = p15.sinceRefresh + p16;

    if p15.sinceRefresh < 1 then
        return nil;
    end;

    p15.sinceRefresh = 0;
    p15:refresh();
end;

function u4.refresh(p17) -- Line: 69
    -- upvalues: Workspace (copy), formatBenefitTimer (copy)
    if not (p17.container and p17.template) then
        return nil;
    end;

    local v18 = Workspace:GetServerTimeNow();
    local v19 = p17:activeBenefits(v18);

    for i, v in p17.rows do
        local v20 = v19[i];

        if v20 ~= nil then
            v20 = v20.style;
        end;

        if v20 ~= v.style then
            v.button:Destroy();
            p17.rows[i] = nil;
            p17.descriptions[i] = nil;
        end;
    end;

    for i, v in v19 do
        p17.descriptions[i] = v.description;
        local v21 = p17.rows[i] or p17:createRow(i, v.style);

        if v.expiresAt ~= nil then
            v21.timer.Text = formatBenefitTimer(v.expiresAt - v18);
        end;
    end;
end;

function u4.activeBenefits(p22, p23) -- Line: 97
    -- upvalues: passLuckFor (copy), sumBoosts (copy), BENEFIT_STYLES (copy), latestExpiry (copy), LUCK_PASS_STYLE (copy), GOLD_PASS_NAME (copy), DIG_POWER_PASS_NAME (copy), WALK_SPEED_PASS_NAME (copy), hasVip (copy)
    local v24 = {};
    local data = p22.data;
    local v25 = passLuckFor(data);
    local v26 = sumBoosts(p22.personalBoosts, p23);

    if v25 < v26 then
        v24.Luck = {
            style = BENEFIT_STYLES.Luck,
            description = `{v26}x Luck`,
            expiresAt = latestExpiry(p22.personalBoosts)
        };
    elseif v25 > 0 then
        v24.Luck = {
            style = LUCK_PASS_STYLE,
            description = `{v25}x Luck`
        };
    end;

    local v27 = p22.luck:getServerBoost();

    if v27 then
        v24.ServerLuck = {
            style = BENEFIT_STYLES.ServerLuck,
            description = `{v27.multiplier}x Luck`,
            expiresAt = v27.expiresAt
        };
    end;

    p22:addPass(v24, "Gold", GOLD_PASS_NAME);
    p22:addPass(v24, "DigPower", DIG_POWER_PASS_NAME);
    p22:addPass(v24, "WalkSpeed", WALK_SPEED_PASS_NAME);

    if hasVip(data) then
        v24.VipLuck = {
            style = BENEFIT_STYLES.VipLuck,
            description = BENEFIT_STYLES.VipLuck.description
        };
        v24.RichTourists = {
            style = BENEFIT_STYLES.RichTourists,
            description = BENEFIT_STYLES.RichTourists.description
        };
    end;

    return v24;
end;

function u4.addPass(p28, p29, p30, p31) -- Line: 142
    -- upvalues: ownsPass (copy), BENEFIT_STYLES (copy)
    if not ownsPass(p28.data, p31) then
        return nil;
    end;

    local v32 = BENEFIT_STYLES[p30];
    local v33 = {
        style = v32
    };
    local description = v32.description;
    v33.description = description == nil and "" or description;
    p29[p30] = v33;
end;

function u4.createRow(u34, u35, p36) -- Line: 160
    -- upvalues: WFChain (copy)
    local v37 = u34.template:Clone();
    v37.Name = u35;
    v37.Image = p36.image;
    v37.LayoutOrder = p36.layoutOrder;
    local v38 = WFChain(v37, "Timer");
    v38.Visible = not p36.permanent;
    v37.Visible = true;
    v37.Parent = u34.container;
    u34.tooltip:bind(v37, p36, function() -- Line: 169
        -- upvalues: u34 (copy), u35 (copy)
        local v39 = u34.descriptions[u35];

        return v39 == nil and "" or v39;
    end);
    local v40 = {
        button = v37,
        timer = v38,
        style = p36
    };
    u34.rows[u35] = v40;

    return v40;
end;

Reflect.defineMetadata(u4, "identifier", "client/controllers/ui/BenefitsController@BenefitsController");
Reflect.defineMetadata(u4, "flamework:parameters", { "client/controllers/data/DataController@DataController", "client/controllers/ui/LuckController@LuckController", "client/controllers/ui/BenefitTooltipController@BenefitTooltipController" });
Reflect.defineMetadata(u4, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick", "client/controllers/data/DataController@OnDataChanged" });
Reflect.decorate(u4, "$:flamework@Controller", Controller, { {} });

return {
    BenefitsController = u4
};