-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(ReplicatedStorage.Library.Types.AssetSizeClassification);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local u1 = table.freeze({
    {
        MinimumScale = 45,
        Prefix = "GARGANTUAN",
        RichText = "<font color=\"#FFD700\">GARGANTUAN</font>",
        Color = Color3.fromRGB(255, 215, 0)
    },
    {
        MinimumScale = 25,
        Prefix = "TITANIC",
        RichText = "<font color=\"#9B51E0\">TITANIC</font>",
        Color = Color3.fromRGB(155, 81, 224)
    },
    {
        MinimumScale = 10,
        Prefix = "HUGE",
        RichText = "<font color=\"#2F80ED\">HUGE</font>",
        Color = Color3.fromRGB(47, 128, 237)
    },
    {
        MinimumScale = 5,
        Prefix = "BIG",
        RichText = "<font color=\"#34C759\">BIG</font>",
        Color = Color3.fromRGB(52, 199, 89)
    }
});
local u2 = Log.new();

return {
    Resolve = function(p3) -- Line: 52, Name: Resolve
        -- upvalues: Asserts (copy), u1 (copy)
        Asserts.number(p3);

        for _, v in ipairs(u1) do
            if v.MinimumScale <= p3 then
                return v;
            end;
        end;

        return nil;
    end,

    GetTiers = function() -- Line: 63, Name: GetTiers
        -- upvalues: u2 (copy), u1 (copy)
        u2:AtTrace():Log("Read shared asset size classification tiers");

        return u1;
    end
};