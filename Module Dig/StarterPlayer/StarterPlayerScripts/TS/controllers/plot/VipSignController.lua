-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local CollectionService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").CollectionService;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "monetization", "Vip");
local VIP_GAMEPASS_NAME = v1.VIP_GAMEPASS_NAME;
local hasVip = v1.hasVip;
local TutorialStep = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "tutorial", "TutorialConfig").TutorialStep;
local u2 = { "Incentive", "SurfaceGui", "Frame", "RobuxBuy" };
local u3 = setmetatable({}, {
    __tostring = function() -- Line: 16, Name: __tostring
        return "VipSignController";
    end
});
u3.__index = u3;

function u3.new(...) -- Line: 21
    -- upvalues: u3 (ref)
    local v4 = setmetatable({}, u3);

    return v4:constructor(...) or v4;
end;

function u3.constructor(p5, p6, p7, p8) -- Line: 25
    p5.plot = p6;
    p5.dataController = p7;
    p5.tutorial = p8;
    p5.owned = false;
    p5.tutorialDone = false;
end;

function u3.onStart(u9) -- Line: 32
    -- upvalues: TutorialStep (copy), hasVip (copy)
    u9.tutorial:onStepChanged(function(p10) -- Line: 33
        -- upvalues: u9 (copy), TutorialStep (ref)
        u9.tutorialDone = TutorialStep.Done <= p10;
        u9:refresh();
    end);
    task.spawn(function() -- Line: 37
        -- upvalues: u9 (copy), hasVip (ref)
        u9.owned = hasVip(u9.dataController:getData());
        local v11, u12 = u9.plot:awaitPlotNumber():await();

        if not v11 or u12 == nil then
            return nil;
        end;

        u9.plot:observePlots(function(p13, p14, p15) -- Line: 43
            -- upvalues: u12 (copy), u9 (ref)
            local VIP = p13:FindFirstChild("VIP");
            local v16;

            if VIP == nil then
                v16 = VIP;
            else
                v16 = VIP:IsA("Model");
            end;

            if not v16 then
                return nil;
            end;

            if p14 ~= u12 then
                u9:setVisible(VIP, false);

                return nil;
            end;

            u9:wireBuyButton(VIP);
            u9.ownSign = VIP;
            p15:Add(function() -- Line: 58
                -- upvalues: u9 (ref)
                u9.ownSign = nil;

                return u9.ownSign;
            end);
            u9:refresh();
        end);
    end);
end;

function u3.onDataChanged(p17, p18, p19) -- Line: 66
    -- upvalues: hasVip (copy)
    if table.find(p18, "Gamepasses") == nil then
        return nil;
    end;

    p17.owned = hasVip(p19);
    p17:refresh();
end;

function u3.refresh(p20) -- Line: 73
    if p20.ownSign then
        p20:setVisible(p20.ownSign, p20.tutorialDone and not p20.owned);
    end;
end;

function u3.wireBuyButton(p21, p22) -- Line: 78
    -- upvalues: u2 (copy), VIP_GAMEPASS_NAME (copy), CollectionService (copy)
    for _, v in u2 do
        if p22 ~= nil then
            p22 = p22:FindFirstChild(v);
        end;
    end;

    local v23;

    if p22 == nil then
        v23 = p22;
    else
        v23 = p22:IsA("ImageButton");
    end;

    if not v23 then
        return nil;
    end;

    p22:SetAttribute("name", VIP_GAMEPASS_NAME);
    CollectionService:AddTag(p22, "ShopButton");
    local Price = p22:FindFirstChild("Price");
    local v24;

    if Price == nil then
        v24 = Price;
    else
        v24 = Price:IsA("TextLabel");
    end;

    if not v24 then
        return nil;
    end;

    Price:SetAttribute("name", VIP_GAMEPASS_NAME);
    CollectionService:AddTag(Price, "ShopPrice");
end;

function u3.setVisible(p25, p26, p27) -- Line: 107
    for _, descendant in p26:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = p27 and 0 or 1;
            descendant.CanCollide = p27;
        elseif descendant:IsA("SurfaceGui") then
            descendant.Enabled = p27;
        end;
    end;
end;

Reflect.defineMetadata(u3, "identifier", "client/controllers/plot/VipSignController@VipSignController");
Reflect.defineMetadata(u3, "flamework:parameters", { "client/controllers/plot/PlotController@PlotController", "client/controllers/data/DataController@DataController", "client/controllers/tutorial/TutorialController@TutorialController" });
Reflect.defineMetadata(u3, "flamework:implements", { "$:flamework@OnStart", "client/controllers/data/DataController@OnDataChanged" });
Reflect.decorate(u3, "$:flamework@Controller", Controller, { {} });

return {
    VipSignController = u3
};