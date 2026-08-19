-- Decompiled with Potassium's decompiler.

local v1 = {
    {
        Name = "AeroStep",
        Id = "rbxassetid://84731485348206",
        Loop = true
    },
    {
        Name = "Clapping",
        Id = "rbxassetid://111663165866774",
        Loop = true
    },
    {
        Name = "Clean Groove",
        Id = "rbxassetid://117078180011763",
        Loop = true
    },
    {
        Name = "Confused",
        Id = "rbxassetid://126355732519337",
        Loop = true
    },
    {
        Name = "Default Dance",
        Id = "rbxassetid://137809485360221",
        Loop = true
    },
    {
        Name = "Floss",
        Id = "rbxassetid://130100106368012",
        Loop = true
    },
    {
        Name = "Fresh",
        Id = "rbxassetid://136072457828791",
        Loop = true
    },
    {
        Name = "Headless",
        Id = "rbxassetid://119269609511601",
        Loop = true
    },
    {
        Name = "Helicopter",
        Id = "rbxassetid://88975583071208",
        Loop = true
    },
    {
        Name = "Hello World",
        Id = "rbxassetid://110389351572851",
        Loop = true
    },
    {
        Name = "I\'ll Break You",
        Id = "rbxassetid://136828045704281",
        Loop = true
    },
    {
        Name = "Infinite Dab",
        Id = "rbxassetid://118591620467973",
        Loop = true
    },
    {
        Name = "JumpStyle",
        Id = "rbxassetid://99585764458684",
        Loop = true
    },
    {
        Name = "Kazotsky Kick",
        Id = "rbxassetid://132503970002236",
        Loop = true
    },
    {
        Name = "Loud Laugh",
        Id = "rbxassetid://101165757838083",
        Loop = false
    },
    {
        Name = "PP Music",
        Id = "rbxassetid://102752540336052",
        Loop = true
    },
    {
        Name = "Penguin Walk",
        Id = "rbxassetid://105557640171240",
        Loop = true
    },
    {
        Name = "Peter Parker",
        Id = "rbxassetid://130648651527484",
        Loop = true
    },
    {
        Name = "Reanimated",
        Id = "rbxassetid://88205593143729",
        Loop = true
    },
    {
        Name = "Relief",
        Id = "rbxassetid://134198373823433",
        Loop = false
    },
    {
        Name = "RickRoll",
        Id = "rbxassetid://76480514791074",
        Loop = true
    },
    {
        Name = "Sea Santis",
        Id = "rbxassetid://85539669660238",
        Loop = true
    },
    {
        Name = "Skipping Happily",
        Id = "rbxassetid://71080670863771",
        Loop = true
    },
    {
        Name = "Spin",
        Id = "rbxassetid://124642442913993",
        Loop = true
    },
    {
        Name = "T-Pose",
        Id = "rbxassetid://97752278905164",
        Loop = true
    },
    {
        Name = "Take The L",
        Id = "rbxassetid://119035723656164",
        Loop = true
    },
    {
        Name = "Thiller",
        Id = "rbxassetid://92004887917464",
        Loop = true
    },
    {
        Name = "WalkyWalk",
        Id = "rbxassetid://100009623479489",
        Loop = true
    },
    {
        Name = "Whoa, Whoa, Whoa, Hold On.",
        Id = "rbxassetid://128893768133128",
        Loop = true
    }
};
local u2 = {};
local v3 = { "rbxassetid://130100106368012", "rbxassetid://117078180011763", "rbxassetid://132503970002236", "rbxassetid://76480514791074", "rbxassetid://89065480825779", "rbxassetid://127235551183602" };

for _, v in v1 do
    u2[v.Name] = v;
end;

return table.freeze({
    Dances = v3,
    Emotes = v1,
    Idle = "rbxassetid://106224055511865",
    Wave = "rbxassetid://85340114311326",
    Talk = "rbxassetid://116838452780553",

    GetEmote = function(p4) -- Line: 87, Name: GetEmote
        -- upvalues: u2 (copy)
        if type(p4) == "string" then
            return u2[p4];
        end;

        return nil;
    end,

    DanceSeconds = 10,
    TalkSeconds = 2,
    FadeTime = 0.3
});