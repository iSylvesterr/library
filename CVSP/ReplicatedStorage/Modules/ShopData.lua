-- Decompiled with Potassium's decompiler.

return {
    ShopOrders = {
        EggShop = { "Capybara Egg", "Alpha Capybara Egg", "Archer Capybara Egg", "Magic Capybara Egg", "Ghost Capybara Egg", "Golem Capybara Egg", "Robot Capybara Egg", "Disco Capybara Egg", "Angel Capybara Egg" },
        GearShop = { "Hatch Hammer", "Nametag", "Mutation Sponge", "Boombox", "Bizarre Stopwatch" },
        Martian = { "Raygun", "Alien Tesla", "Totem Of Stars" },
        Timbles = { "Totem Of Might", "Totem Of Marrow", "Rainbow Scroll" },
        ["King Capybara"] = { "Gilded Hatch Hammer", "Gold Scroll", "Totem Of Status" },
        Jester = { "Moonlit Scroll", "Chilly Scroll", "Toasty Scroll", "Tranquil Scroll", "Shocked Scroll", "Glitched Scroll" }
    },
    TravelingMerchantPool = { "King Capybara", "Martian", "Timbles", "Jester" },

    getData = function(p1) -- Line: 55, Name: getData
        return script:FindFirstChild(p1) or nil;
    end
};