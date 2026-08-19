-- Decompiled with Potassium's decompiler.

local Info = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Info");
local Images = require(Info:WaitForChild("Images"));

return {
    EMOTE_COOLDOWN = 0.2,
    EMOTES_PER_ROW = 4,
    Emotes = {
        Hi = {
            id = "Hi",
            vipOnly = false,
            order = 1,
            image = Images.EM_HI
        },
        Cheer = {
            id = "Cheer",
            vipOnly = false,
            order = 2,
            image = Images.EM_CHEER
        },
        Laugh = {
            id = "Laugh",
            vipOnly = false,
            order = 3,
            image = Images.EM_LAUGH
        },
        Cry = {
            id = "Cry",
            vipOnly = false,
            order = 4,
            image = Images.EM_CRY
        },
        Applause = {
            id = "Applause",
            vipOnly = true,
            order = 5,
            image = Images.EM_APPLAUSE
        },
        Angry = {
            id = "Angry",
            vipOnly = true,
            order = 6,
            image = Images.EM_ANGRY
        },
        Amazed = {
            id = "Amazed",
            vipOnly = true,
            order = 7,
            image = Images.EM_AMAZED
        },
        Scream = {
            id = "Scream",
            vipOnly = true,
            order = 8,
            image = Images.EM_SCREAM
        },
        Think = {
            id = "Think",
            vipOnly = true,
            order = 9,
            image = Images.EM_THINK
        },
        Confused = {
            id = "Confused",
            vipOnly = true,
            order = 10,
            image = Images.EM_CONFUSED
        },
        EvilLaugh = {
            id = "EvilLaugh",
            vipOnly = true,
            order = 11,
            image = Images.EM_EVIL_LAUGH
        },
        Lightning = {
            id = "Lightning",
            vipOnly = true,
            order = 12,
            image = Images.EM_LIGHTNING
        }
    }
};