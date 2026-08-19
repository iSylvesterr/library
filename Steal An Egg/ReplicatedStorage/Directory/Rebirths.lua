-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local v1 = t.interface({
    RequiredSpeedPower = t.number
});
local v2 = t.interface({
    Name = t.string,
    RebirthNumber = t.number,
    Multiplier = t.number,
    Requirements = v1
});
local v3 = {
    {
        Name = "Rebirth 1",
        RebirthNumber = 1,
        Multiplier = 1.5,
        Requirements = {
            RequiredSpeedPower = 4061
        }
    },
    {
        Name = "Rebirth 2",
        RebirthNumber = 2,
        Multiplier = 2,
        Requirements = {
            RequiredSpeedPower = 18427
        }
    },
    {
        Name = "Rebirth 3",
        RebirthNumber = 3,
        Multiplier = 2.5,
        Requirements = {
            RequiredSpeedPower = 154627
        }
    },
    {
        Name = "Rebirth 4",
        RebirthNumber = 4,
        Multiplier = 3,
        Requirements = {
            RequiredSpeedPower = 2540792
        }
    },
    {
        Name = "Rebirth 5",
        RebirthNumber = 5,
        Multiplier = 3.5,
        Requirements = {
            RequiredSpeedPower = 20679267
        }
    },
    {
        Name = "Rebirth 6",
        RebirthNumber = 6,
        Multiplier = 4,
        Requirements = {
            RequiredSpeedPower = 680760765
        }
    },
    {
        Name = "Rebirth 7",
        RebirthNumber = 7,
        Multiplier = 5,
        Requirements = {
            RequiredSpeedPower = 22409952297
        }
    },
    {
        Name = "Rebirth 8",
        RebirthNumber = 8,
        Multiplier = 6,
        Requirements = {
            RequiredSpeedPower = 737712178824
        }
    },
    {
        Name = "Rebirth 9",
        RebirthNumber = 9,
        Multiplier = 7.5,
        Requirements = {
            RequiredSpeedPower = 24284712282697
        }
    },
    {
        Name = "Rebirth 10",
        RebirthNumber = 10,
        Multiplier = 10,
        Requirements = {
            RequiredSpeedPower = 799427293040270
        }
    },
    {
        Name = "Rebirth 11",
        RebirthNumber = 11,
        Multiplier = 12,
        Requirements = {
            RequiredSpeedPower = 2.63163091825803e16
        }
    },
    {
        Name = "Rebirth 12",
        RebirthNumber = 12,
        Multiplier = 15,
        Requirements = {
            RequiredSpeedPower = 8.66305335109115e17
        }
    },
    {
        Name = "Rebirth 13",
        RebirthNumber = 13,
        Multiplier = 20,
        Requirements = {
            RequiredSpeedPower = 9.38778223074874e20
        }
    },
    {
        Name = "Rebirth 14",
        RebirthNumber = 14,
        Multiplier = 35,
        Requirements = {
            RequiredSpeedPower = 1.10241989458133e27
        }
    },
    {
        Name = "Rebirth 15",
        RebirthNumber = 15,
        Multiplier = 50,
        Requirements = {
            RequiredSpeedPower = 1.29458651052644e33
        }
    },
    {
        Name = "Rebirth 16",
        RebirthNumber = 16,
        Multiplier = 75,
        Requirements = {
            RequiredSpeedPower = 1.52025035240634e39
        }
    },
    {
        Name = "Rebirth 17",
        RebirthNumber = 17,
        Multiplier = 100,
        Requirements = {
            RequiredSpeedPower = 1.93459992143063e48
        }
    },
    {
        Name = "Rebirth 18",
        RebirthNumber = 18,
        Multiplier = 200,
        Requirements = {
            RequiredSpeedPower = 2.89102105233387e63
        }
    }
};

if Constants.IS_STUDIO then
    for i, v in pairs(v3) do
        local v4, v5 = v2(v);
        local v6 = `Bad rebirth entry {i}: {v5}`;
        assert(v4, v6);
        local v7 = v.RebirthNumber == i;
        local v8 = `Rebirth entry {i} has mismatched RebirthNumber`;
        assert(v7, v8);
    end;
end;

return v3;