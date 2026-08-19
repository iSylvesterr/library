-- Decompiled with Potassium's decompiler.

local Pipeline = require(game:GetService("ReplicatedStorage").Directory.Animations.Pipeline);

return table.freeze({
    Default = {
        idle = { Pipeline:GetAndSerializeAnimation("http://www.roblox.com/asset/?id=507766666"), Pipeline:GetAndSerializeAnimation("http://www.roblox.com/asset/?id=507766951"), Pipeline:GetAndSerializeAnimation("http://www.roblox.com/asset/?id=507766388", {
                DropWeight = 9
            }) },
        smoothBodyTurn = { Pipeline:GetAndSerializeAnimation("rbxassetid://507777826", {
                Looped = false,
                Play = { nil, 0.2 }
            }) },
        walk = { Pipeline:GetAndSerializeAnimation("http://www.roblox.com/asset/?id=507777826", {
                DropWeight = 10
            }) },
        run = { Pipeline:GetAndSerializeAnimation("http://www.roblox.com/asset/?id=507767714", {
                DropWeight = 10
            }) },
        swim = { Pipeline:GetAndSerializeAnimation("http://www.roblox.com/asset/?id=507784897", {
                DropWeight = 10
            }) },
        swimidle = { Pipeline:GetAndSerializeAnimation("http://www.roblox.com/asset/?id=507785072", {
                DropWeight = 10
            }) },
        jump = { Pipeline:GetAndSerializeAnimation("http://www.roblox.com/asset/?id=507765000", {
                DropWeight = 10
            }) },
        fall = { Pipeline:GetAndSerializeAnimation("http://www.roblox.com/asset/?id=507767968", {
                DropWeight = 10
            }) },
        climb = { Pipeline:GetAndSerializeAnimation("http://www.roblox.com/asset/?id=507765644", {
                DropWeight = 10
            }) },
        sit = { Pipeline:GetAndSerializeAnimation("http://www.roblox.com/asset/?id=2506281703", {
                DropWeight = 10
            }) },
        toolnone = { Pipeline:GetAndSerializeAnimation("http://www.roblox.com/asset/?id=507768375", {
                DropWeight = 10
            }) },
        toolslash = { Pipeline:GetAndSerializeAnimation("http://www.roblox.com/asset/?id=522635514", {
                DropWeight = 10
            }) },
        toollunge = { Pipeline:GetAndSerializeAnimation("http://www.roblox.com/asset/?id=522638767", {
                DropWeight = 10
            }) }
    }
});