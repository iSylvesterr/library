-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local Players = v1.Players;
local RunService = v1.RunService;
local u2 = { "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand" };
local u3 = Enum.RenderPriority.Character.Value + 1;
local u4 = setmetatable({}, {
    __tostring = function() -- Line: 16, Name: __tostring
        return "FirstPersonVisibilityController";
    end
});
u4.__index = u4;

function u4.new(...) -- Line: 21
    -- upvalues: u4 (ref)
    local v5 = setmetatable({}, u4);

    return v5:constructor(...) or v5;
end;

function u4.constructor(p6, p7, p8) -- Line: 25
    -- upvalues: Players (copy)
    p6.shovel = p7;
    p6.detector = p8;
    p6.localPlayer = Players.LocalPlayer;
    p6.arms = {};
end;

function u4.onStart(u9) -- Line: 31
    -- upvalues: RunService (copy), u3 (copy)
    local Character = u9.localPlayer.Character;

    if Character then
        task.spawn(function() -- Line: 34
            -- upvalues: u9 (copy), Character (copy)
            return u9:bindCharacter(Character);
        end);
    end;

    u9.localPlayer.CharacterAdded:Connect(function(p10) -- Line: 38
        -- upvalues: u9 (copy)
        return u9:bindCharacter(p10);
    end);
    u9.localPlayer.CharacterRemoving:Connect(function() -- Line: 41
        -- upvalues: u9 (copy)
        u9.hiddenReference = nil;
        u9.arms = {};
    end);
    RunService:BindToRenderStep("FirstPersonGearVisibility", u3, function() -- Line: 45
        -- upvalues: u9 (copy)
        return u9:update();
    end);
end;

function u4.bindCharacter(p11, p12) -- Line: 49
    -- upvalues: u2 (copy)
    local Head = p12:WaitForChild("Head", 10);
    local v13 = {};

    for _, v in u2 do
        local v14 = p12:WaitForChild(v, 10);
        local v15;

        if v14 == nil then
            v15 = v14;
        else
            v15 = v14:IsA("BasePart");
        end;

        if v15 then
            table.insert(v13, v14);
        end;
    end;

    local v16 = p11.localPlayer.Character ~= p12;

    if not v16 then
        local v17;

        if Head == nil then
            v17 = Head;
        else
            v17 = Head:IsA("BasePart");
        end;

        v16 = not v17;
    end;

    if v16 then
        return nil;
    end;

    p11.arms = v13;
    p11.hiddenReference = Head;
end;

function u4.update(p18) -- Line: 76
    local hiddenReference = p18.hiddenReference;

    if hiddenReference ~= nil then
        hiddenReference = hiddenReference.LocalTransparencyModifier;
    end;

    if hiddenReference == nil then
        return nil;
    end;

    local v19 = p18.shovel:isLocalEquipped();
    local v20 = p18.detector:isLocalHeld();
    p18:applyTransparency(p18.shovel:getLocalGearParts(), v19 and 0 or hiddenReference);
    p18:applyTransparency(p18.detector:getLocalGearParts(), v20 and 0 or hiddenReference);
    p18:applyTransparency(p18.arms, (v19 or v20) and 0 or hiddenReference);
end;

function u4.applyTransparency(p21, p22, p23) -- Line: 91
    if not p22 then
        return nil;
    end;

    for _, v in p22 do
        v.LocalTransparencyModifier = p23;
    end;
end;

Reflect.defineMetadata(u4, "identifier", "client/controllers/character/FirstPersonVisibilityController@FirstPersonVisibilityController");
Reflect.defineMetadata(u4, "flamework:parameters", { "client/controllers/world/ShovelController@ShovelController", "client/controllers/world/DetectorController@DetectorController" });
Reflect.defineMetadata(u4, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u4, "$:flamework@Controller", Controller, { {} });

return {
    FirstPersonVisibilityController = u4
};