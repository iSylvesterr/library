-- Decompiled with Potassium's decompiler.

local Janitor = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 7, Name: __tostring
        return "CustomPrompt";
    end
});
u1.__index = u1;

function u1.new(...) -- Line: 12
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(p3, p4) -- Line: 16
    -- upvalues: Janitor (copy)
    p3.janitor = Janitor.new();
    local ProximityPrompt = Instance.new("ProximityPrompt");
    ProximityPrompt.ActionText = p4.actionText;
    local objectText = p4.objectText;
    ProximityPrompt.ObjectText = objectText == nil and "" or objectText;
    ProximityPrompt.RequiresLineOfSight = false;
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
    local holdDuration = p4.holdDuration;
    ProximityPrompt.HoldDuration = holdDuration == nil and 0 or holdDuration;
    local maxDistance = p4.maxDistance;
    ProximityPrompt.MaxActivationDistance = maxDistance == nil and 7 or maxDistance;

    if p4.keyboardKeyCode ~= nil then
        ProximityPrompt.KeyboardKeyCode = p4.keyboardKeyCode;
    end;

    if p4.uiOffset ~= nil then
        ProximityPrompt.UIOffset = p4.uiOffset;
    end;

    p3.Prompt = ProximityPrompt;
end;

function u1.onTriggered(p5, p6) -- Line: 45
    p5.janitor:Add(p5.Prompt.Triggered:Connect(p6), "Disconnect");
end;

function u1.onHoldBegan(p7, p8) -- Line: 48
    p7.janitor:Add(p7.Prompt.PromptButtonHoldBegan:Connect(p8), "Disconnect");
end;

function u1.onHoldEnded(p9, p10) -- Line: 51
    p9.janitor:Add(p9.Prompt.PromptButtonHoldEnded:Connect(p10), "Disconnect");
end;

function u1.Destroy(p11) -- Line: 54
    p11.janitor:Destroy();
    p11.Prompt:Destroy();
end;

return {
    CustomPrompt = u1
};