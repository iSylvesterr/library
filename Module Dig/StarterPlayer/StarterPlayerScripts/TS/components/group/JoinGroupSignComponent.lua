-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local BaseComponent = v1.BaseComponent;
local Component = v1.Component;
local DETECTOR_TIER_ORDER = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Detectors").DETECTOR_TIER_ORDER;
local GROUP_REWARD_DETECTOR_ID = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "group", "GroupRewards").GROUP_REWARD_DETECTOR_ID;
local u2 = (table.find(DETECTOR_TIER_ORDER, GROUP_REWARD_DETECTOR_ID) or 0) - 1;

local function _(p3, p4) -- Line: 14
    -- upvalues: u2 (copy)
    return u2 <= p4;
end;

local v5 = 0;
local v6 = {};
local u7 = {};

for i, v in DETECTOR_TIER_ORDER do
    if u2 <= i - 1 == true then
        v5 = v5 + 1;
        v6[v5] = v;
    end;
end;

for _, v in v6 do
    u7[v] = true;
end;

local u8 = setmetatable({}, {
    __tostring = function() -- Line: 33, Name: __tostring
        return "JoinGroupSignComponent";
    end,

    __index = BaseComponent
});
u8.__index = u8;

function u8.new(...) -- Line: 39
    -- upvalues: u8 (ref)
    local v9 = setmetatable({}, u8);

    return v9:constructor(...) or v9;
end;

function u8.constructor(p10, p11) -- Line: 43
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p10);
    p10.dataController = p11;
end;

function u8.onStart(p12) -- Line: 47
    if p12:shouldHide(p12.dataController:getData()) then
        p12:hide();
    end;
end;

function u8.onDataChanged(p13, p14, p15) -- Line: 52
    if table.find(p14, "GroupRewardClaimed") == nil and table.find(p14, "OwnedDetectors") == nil then
        return nil;
    end;

    if p13:shouldHide(p15) then
        p13:hide();
    end;
end;

function u8.shouldHide(p16, p17) -- Line: 60
    -- upvalues: u7 (copy)
    local GroupRewardClaimed = p17.GroupRewardClaimed;

    if not GroupRewardClaimed then
        local function _(p18) -- Line: 66
            -- upvalues: u7 (ref)
            return u7[p18] ~= nil;
        end;

        GroupRewardClaimed = false;

        for i, v in p17.OwnedDetectors do
            local _ = i - 1;

            if u7[v] ~= nil then
                GroupRewardClaimed = true;
                break;
            end;
        end;
    end;

    return GroupRewardClaimed;
end;

function u8.hide(p19) -- Line: 81
    for _, descendant in p19.instance:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Transparency = 1;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            descendant.Transparency = 1;
        elseif descendant:IsA("SurfaceGui") or descendant:IsA("BillboardGui") then
            descendant.Enabled = false;
        end;
    end;
end;

Reflect.defineMetadata(u8, "identifier", "client/components/group/JoinGroupSignComponent@JoinGroupSignComponent");
Reflect.defineMetadata(u8, "flamework:parameters", { "client/controllers/data/DataController@DataController" });
Reflect.defineMetadata(u8, "flamework:implements", { "$:flamework@OnStart", "client/controllers/data/DataController@OnDataChanged" });
Reflect.decorate(u8, "$c:components@Component", Component, {
    {
        tag = "JoinGroupSign",
        attributes = {},
        instanceGuard = t.instanceIsA("Model")
    }
});

return {
    JoinGroupSignComponent = u8
};