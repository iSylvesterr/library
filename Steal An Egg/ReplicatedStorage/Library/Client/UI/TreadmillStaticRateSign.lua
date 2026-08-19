-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Commas = require(ReplicatedStorage.Library.Functions.Commas);

return {
    Apply = function(p1, p2, p3) -- Line: 30, Name: Apply
        -- upvalues: Asserts (copy), Commas (copy)
        Asserts.Instance(p1);
        Asserts.Color3(p2);
        Asserts.number(p3);
        local SpeedPerSecond = p1.SpeedPerSecond;
        local v4 = SpeedPerSecond:IsA("BasePart");
        local v5 = `Treadmill "{p1.Name}" SpeedPerSecond must be a BasePart`;
        assert(v4, v5);
        local BillboardGui = SpeedPerSecond.BillboardGui;
        local v6 = BillboardGui:IsA("BillboardGui");
        local v7 = `Treadmill "{p1.Name}" SpeedPerSecond.BillboardGui must be a BillboardGui`;
        assert(v6, v7);
        local TextLabel = BillboardGui.Frame.TextLabel;
        local v8 = TextLabel:IsA("TextLabel");
        local v9 = `Treadmill "{p1.Name}" SpeedPerSecond.BillboardGui.Frame.TextLabel must be a TextLabel`;
        assert(v8, v9);
        TextLabel.TextColor3 = p2;
        TextLabel.Text = `+{Commas(p3)}/step`;

        return BillboardGui;
    end
};