-- Decompiled with Potassium's decompiler.

local v1 = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "ui", "VipTag");
local VIP_GRADIENT = v1.VIP_GRADIENT;
local VIP_GRADIENT_ROTATION = v1.VIP_GRADIENT_ROTATION;

return {
    BENEFIT_STYLES = {
        Luck = {
            title = "Luck",
            image = "rbxassetid://71941753657861",
            rotation = -90,
            layoutOrder = 10,
            permanent = false,
            gradient = ColorSequence.new(Color3.fromRGB(15, 237, 0), Color3.fromRGB(238, 239, 228))
        },
        ServerLuck = {
            title = "Server Luck",
            image = "rbxassetid://70516451170000",
            rotation = -90,
            layoutOrder = 20,
            permanent = false,
            gradient = ColorSequence.new(Color3.fromRGB(194, 0, 242), Color3.fromRGB(245, 173, 229))
        },
        Gold = {
            title = "Gold",
            image = "rbxassetid://76115661427471",
            rotation = 90,
            layoutOrder = 30,
            permanent = true,
            description = "2x Gold",
            gradient = ColorSequence.new(Color3.fromRGB(248, 233, 0), Color3.fromRGB(248, 177, 0))
        },
        DigPower = {
            title = "Dig Power",
            image = "rbxassetid://89926561749973",
            rotation = 90,
            layoutOrder = 40,
            permanent = true,
            description = "2x Dig Power",
            gradient = ColorSequence.new(Color3.fromRGB(231, 109, 0), Color3.fromRGB(241, 20, 0))
        },
        WalkSpeed = {
            title = "Walk Speed",
            image = "rbxassetid://101833945012200",
            rotation = 90,
            layoutOrder = 50,
            permanent = true,
            description = "2x Walk Speed",
            gradient = ColorSequence.new(Color3.fromRGB(0, 247, 130), Color3.fromRGB(0, 164, 241))
        },
        VipLuck = {
            title = "VIP Luck",
            image = "rbxassetid://111940385998001",
            layoutOrder = 100,
            permanent = true,
            description = "2x Luck",
            gradient = VIP_GRADIENT,
            rotation = VIP_GRADIENT_ROTATION
        },
        RichTourists = {
            title = "Rich Tourists",
            image = "rbxassetid://111232032852487",
            layoutOrder = 110,
            permanent = true,
            description = "2x Gold",
            gradient = VIP_GRADIENT,
            rotation = VIP_GRADIENT_ROTATION
        }
    },
    LUCK_PASS_STYLE = {
        title = "Luck",
        image = "rbxassetid://71941753657861",
        rotation = 90,
        layoutOrder = 10,
        permanent = true,
        gradient = ColorSequence.new(Color3.fromRGB(227, 238, 2), Color3.fromRGB(22, 238, 0))
    }
};