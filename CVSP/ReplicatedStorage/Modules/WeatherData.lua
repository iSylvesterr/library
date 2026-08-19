-- Decompiled with Potassium's decompiler.

return {
    getData = function(p1) -- Line: 7, Name: getData
        return script:FindFirstChild(p1) or nil;
    end,

    getAllWeathers = function() -- Line: 11, Name: getAllWeathers
        return script:GetChildren();
    end,

    getIndexList = function() -- Line: 15, Name: getIndexList
        return { "Night", "Meteor Shower", "Rain", "Thunder", "Zen", "Snowy", "Blizzard", "Heatwave", "Red Sun", "Glitch", "Taco Rain", "Reverse Sun" };
    end
};