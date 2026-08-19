-- Decompiled with Potassium's decompiler.

local u3 = {
    toKelvin = function(p1) -- Line: 21, Name: toKelvin
        return p1 + 273;
    end,

    toFahrenheit = function(p2) -- Line: 24, Name: toFahrenheit
        return p2 * 1.8 + 32;
    end
};
local u5 = {
    toCelsius = function(p4) -- Line: 29, Name: toCelsius
        return p4 - 273;
    end
};

function u5.toFahrenheit(p6) -- Line: 32
    -- upvalues: u3 (copy), u5 (copy)
    return u3.toFahrenheit(u5.toCelsius(p6));
end;

local u8 = {
    toCelsius = function(p7) -- Line: 37, Name: toCelsius
        return (p7 - 32) / 1.8;
    end
};

function u8.toKelvin(p9) -- Line: 40
    -- upvalues: u3 (copy), u8 (copy)
    return u3.toKelvin(u8.toCelsius(p9));
end;

return {
    Kelvin = u5,
    Celsius = u3,
    Fahrenheit = u8
};